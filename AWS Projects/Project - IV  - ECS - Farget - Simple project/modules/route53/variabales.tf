# modules/route53/variables.tf
# Variables for the Route 53 module.
variable "project_name" {
  description = "The name of the project."
  type        = string
}

variable "domain_name" {
  description = "The domain name for the public hosted zone."
  type        = string
}

variable "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer."
  type        = string
}

variable "alb_zone_id" {
  description = "The Zone ID of the Application Load Balancer."
  type        = string
}