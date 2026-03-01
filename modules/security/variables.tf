variable "name_prefix" {
  description = "Resource name prefix."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "my_ip_cidr" {
  description = "Client IP in CIDR for SSH ingress."
  type        = string
}

variable "db_port" {
  description = "Database port allowed from bastion."
  type        = number
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
}
