# outputs.tf
# Global outputs for the infrastructure.
output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer."
  value       = module.alb.alb_dns_name
}

output "ecs_service_name" {
  description = "The name of the ECS service."
  value       = module.ecs.ecs_service_name
}

output "ecs_cluster_name" {
  description = "The name of the ECS cluster."
  value       = module.ecs.ecs_cluster_name
}

output "route53_hosted_zone_name" {
  description = "The name of the Route 53 public hosted zone (if created)."
  value       = var.domain_name != "" ? module.route53[0].hosted_zone_name : "N/A (Route 53 not enabled)"
}

output "route53_record_name" {
  description = "The name of the Route 53 A record (if created)."
  value       = var.domain_name != "" ? module.route53[0].record_name : "N/A (Route 53 not enabled)"
}
