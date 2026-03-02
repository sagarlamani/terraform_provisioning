locals {
  environment = var.environment
  name_prefix = "${var.project_name}-${local.environment}"
  db_port     = var.db_engine == "postgres" ? 5432 : 3306

  common_tags = {
    Project     = var.project_name
    Environment = local.environment
    ManagedBy   = "terraform"
  }
}

module "networking" {
  source = "./modules/networking"

  name_prefix               = local.name_prefix
  vpc_cidr                  = var.vpc_cidr
  public_subnet_cidr        = var.public_subnet_cidr
  private_subnet_cidr       = var.private_subnet_cidr
  public_availability_zone  = var.public_availability_zone
  private_availability_zone = var.private_availability_zone
  tags                      = local.common_tags
}

module "security" {
  source = "./modules/security"

  name_prefix = local.name_prefix
  vpc_id      = module.networking.vpc_id
  my_ip_cidr  = var.my_ip_cidr
  db_port     = local.db_port
  tags        = local.common_tags
}

module "bastion" {
  source = "./modules/bastion"

  name_prefix       = local.name_prefix
  subnet_id         = module.networking.public_subnet_id
  security_group_id = module.security.bastion_sg_id
  ami_id            = var.bastion_ami_id
  instance_type     = var.bastion_instance_type
  key_name          = var.bastion_key_name
  user_data         = file("${path.module}/scripts/bastion_bootstrap.sh")
  tags              = local.common_tags
}

module "rds" {
  source = "./modules/rds"

  name_prefix           = local.name_prefix
  engine                = var.db_engine
  engine_version        = var.db_engine_version
  instance_class        = var.db_instance_class
  allocated_storage     = var.db_allocated_storage
  db_name               = var.db_name
  username              = var.db_username
  password              = var.db_password
  db_port               = local.db_port
  private_subnet_id     = module.networking.private_subnet_id
  public_subnet_id      = module.networking.public_subnet_id
  private_az            = var.private_availability_zone
  rds_security_group_id = module.security.rds_sg_id
  tags                  = local.common_tags
}
