variable "name_prefix" {
  description = "Resource name prefix."
  type        = string
}

variable "subnet_id" {
  description = "Public subnet ID for bastion."
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for bastion."
  type        = string
}

variable "ami_id" {
  description = "AMI ID for bastion."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name."
  type        = string
}

variable "user_data" {
  description = "User-data script content."
  type        = string
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
}
