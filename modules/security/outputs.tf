output "bastion_sg_id" {
  description = "Bastion security group ID."
  value       = aws_security_group.bastion.id
}

output "rds_sg_id" {
  description = "RDS security group ID."
  value       = aws_security_group.rds.id
}
