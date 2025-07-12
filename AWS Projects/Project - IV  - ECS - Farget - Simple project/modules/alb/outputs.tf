# modules/alb/outputs.tf
# Outputs for the ALB module.
output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer."
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "The Zone ID of the Application Load Balancer."
  value       = aws_lb.main.zone_id
}

output "alb_security_group_id" {
  description = "The ID of the ALB security group."
  value       = aws_security_group.alb.id
}

output "alb_target_group_arn" {
  description = "The ARN of the ALB target group for ECS tasks."
  value       = aws_lb_target_group.ecs_tasks.arn
}
