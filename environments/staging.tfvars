environment = "staging"
aws_region  = "ap-south-1"

project_name = "terraform-provisioning"

vpc_cidr            = "10.10.0.0/16"
public_subnet_cidr  = "10.10.1.0/24"
private_subnet_cidr = "10.10.2.0/24"

public_availability_zone  = "ap-south-1a"
private_availability_zone = "ap-south-1b"

my_ip_cidr = "223.185.129.74/32"

bastion_ami_id        = "ami-0d44b036bd2b73294"
bastion_instance_type = "t4g.micro"
bastion_key_name      = "bastion-key-pair-stg"

db_engine            = "postgres"
db_engine_version    = "18.2"
db_instance_class    = "db.t4g.micro"
db_allocated_storage = 20
db_name              = "appdb"
db_username          = "appadmin"
db_password          = "password"
