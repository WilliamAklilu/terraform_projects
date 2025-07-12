# variables.tf
# Global variables for the infrastructure.
variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1" # N. Virginia, a common region for Free Tier services
}

variable "project_name" {
  description = "A unique name for the project, used as a prefix for resources."
  type        = string
  default     = "free-tier-app"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "A list of CIDR blocks for the public subnets (must be at least two)."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "container_image" {
  description = "The Docker image for the web application container."
  type        = string
  default     = "nginx:latest"
}

variable "container_port" {
  description = "The port the container listens on."
  type        = number
  default     = 80
}

variable "container_cpu" {
  description = "The CPU units for the Fargate task (256 units = 0.25 vCPU)."
  type        = number
  default     = 256
}

variable "container_memory" {
  description = "The memory in MiB for the Fargate task (512 MiB)."
  type        = number
  default     = 512
}

variable "domain_name" {
  description = "The domain name for Route 53 (optional). Leave empty to skip Route 53."
  type        = string
  default     = "" # Example: "yourdomain.com"
}