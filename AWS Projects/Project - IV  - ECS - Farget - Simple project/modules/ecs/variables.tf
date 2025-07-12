# modules/ecs/variables.tf
# Variables for the ECS module.
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

variable "ecs_task_execution_role_arn" {
  description = "The ARN of the ECS task execution IAM role."
  type        = string
}

variable "container_image" {
  description = "The Docker image for the web application container."
  type        = string
}

variable "container_port" {
  description = "The port the container listens on."
  type        = number
}

variable "container_cpu" {
  description = "The CPU units for the Fargate task."
  type        = number
}

variable "container_memory" {
  description = "The memory in MiB for the Fargate task."
  type        = number
}

variable "alb_target_group_arn" {
  description = "The ARN of the ALB target group for ECS tasks."
  type        = string
}

variable "alb_security_group_id" {
  description = "The ID of the ALB security group."
  type        = string
}

variable "aws_region" {
  description = "The AWS region."
  type        = string
}