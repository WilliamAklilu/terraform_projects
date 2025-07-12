# modules/alb/variables.tf
# Variables for the ALB module.
variable "project_name" {
  description = "The name of the project."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "public_subnet_ids" {
  description = "A list of IDs of the public subnets."
  type        = list(string)
}

variable "container_port" {
  description = "The port the container listens on."
  type        = number
}
