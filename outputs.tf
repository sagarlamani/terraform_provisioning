output "environment" {
  description = "Resolved environment name."
  value       = local.environment
}

output "vpc_id" {
  description = "Created VPC ID."
  value       = module.networking.vpc_id
}

output "public_subnet_id" {
  description = "Public subnet ID."
  value       = module.networking.public_subnet_id
}

output "private_subnet_id" {
  description = "Private subnet ID."
  value       = module.networking.private_subnet_id
}

output "bastion_public_ip" {
  description = "Public IP of bastion host."
  value       = module.bastion.public_ip
}

output "rds_endpoint" {
  description = "RDS endpoint address."
  value       = module.rds.endpoint
}
