variable "name_prefix" {
  description = "Resource name prefix."
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR."
  type        = string
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR."
  type        = string
}

variable "public_availability_zone" {
  description = "AZ for public subnet."
  type        = string
}

variable "private_availability_zone" {
  description = "AZ for private subnet."
  type        = string
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
}
