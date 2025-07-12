# main.tf
# Orchestrates the deployment by calling individual modules.

# Data source to get available Availability Zones in the selected region.
data "aws_availability_zones" "available" {
  state = "available"
}

# Ensure we have at least two availability zones for public subnets.
locals {
  selected_azs = slice(data.aws_availability_zones.available.names, 0, 2)
}

# 1. VPC Module
module "vpc" {
  source = "./modules/vpc"

  project_name      = var.project_name
  vpc_cidr_block    = var.vpc_cidr_block
  public_subnet_cidrs = var.public_subnet_cidrs
  availability_zones = local.selected_azs
}

# 2. IAM Module
module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
}

# 3. ALB Module
module "alb" {
  source = "./modules/alb"

  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  container_port    = var.container_port
}

# 4. ECS Module
module "ecs" {
  source = "./modules/ecs"

  project_name               = var.project_name
  vpc_id                     = module.vpc.vpc_id
  public_subnet_ids          = module.vpc.public_subnet_ids
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  container_image            = var.container_image
  container_port             = var.container_port
  container_cpu              = var.container_cpu
  container_memory           = var.container_memory
  alb_target_group_arn       = module.alb.alb_target_group_arn
  alb_security_group_id      = module.alb.alb_security_group_id
  aws_region                 = var.aws_region
}

# 5. Route 53 Module (Optional)
# This module is conditionally created based on whether domain_name is provided.
module "route53" {
  source = "./modules/route53"
  count  = var.domain_name != "" ? 1 : 0 # Create if domain_name is set

  project_name     = var.project_name
  domain_name      = var.domain_name
  alb_dns_name     = module.alb.alb_dns_name
  alb_zone_id      = module.alb.alb_zone_id
}