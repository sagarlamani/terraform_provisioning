output "id" {
  description = "RDS instance identifier."
  value       = aws_db_instance.this.id
}

output "endpoint" {
  description = "RDS endpoint."
  value       = aws_db_instance.this.endpoint
}
