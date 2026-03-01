variable "environment" {
  description = "Environment name. If empty, terraform.workspace is used."
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
}

variable "project_name" {
  description = "Project prefix used for tagging and names."
  type        = string
  default     = "terraform-provisioning"
}

variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR block."
  type        = string
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR block."
  type        = string
}

variable "public_availability_zone" {
  description = "Availability zone for the public subnet."
  type        = string
}

variable "private_availability_zone" {
  description = "Availability zone for the private subnet and RDS placement."
  type        = string
}

variable "my_ip_cidr" {
  description = "Your public IP in CIDR format (example: 203.0.113.10/32)."
  type        = string
}

variable "bastion_ami_id" {
  description = "AMI ID for bastion EC2 instance."
  type        = string
}

variable "bastion_instance_type" {
  description = "Bastion EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "bastion_key_name" {
  description = "Existing EC2 key pair name for SSH access to bastion."
  type        = string
}

variable "db_engine" {
  description = "Database engine for RDS (postgres or mysql)."
  type        = string
  default     = "postgres"
  validation {
    condition     = contains(["postgres", "mysql"], var.db_engine)
    error_message = "db_engine must be either postgres or mysql."
  }
}

variable "db_engine_version" {
  description = "RDS engine version."
  type        = string
  default     = "16.4"
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Initial allocated storage (GB) for RDS."
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Initial database name."
  type        = string
}

variable "db_username" {
  description = "Master username for RDS."
  type        = string
}

variable "db_password" {
  description = "Master password for RDS."
  type        = string
  sensitive   = true
}
