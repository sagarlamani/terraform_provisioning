variable "name_prefix" {
  description = "Resource name prefix."
  type        = string
}

variable "engine" {
  description = "RDS engine."
  type        = string
}

variable "engine_version" {
  description = "RDS engine version."
  type        = string
}

variable "instance_class" {
  description = "RDS instance class."
  type        = string
}

variable "allocated_storage" {
  description = "Allocated storage in GB."
  type        = number
}

variable "db_name" {
  description = "Initial DB name."
  type        = string
}

variable "username" {
  description = "Master username."
  type        = string
}

variable "password" {
  description = "Master password."
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "DB port."
  type        = number
}

variable "private_subnet_id" {
  description = "Private subnet ID."
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID (used to satisfy DB subnet group two-subnet requirement)."
  type        = string
}

variable "private_az" {
  description = "Private subnet AZ used for RDS placement."
  type        = string
}

variable "rds_security_group_id" {
  description = "RDS security group ID."
  type        = string
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
}
