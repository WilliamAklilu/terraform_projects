# modules/vpc/variables.tf
# Variables for the VPC module.
variable "project_name" {
  description = "The name of the project."
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "A list of CIDR blocks for the public subnets."
  type        = list(string)
}

variable "availability_zones" {
  description = "A list of availability zones to deploy subnets into."
  type        = list(string)
}
