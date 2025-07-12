# modules/ecs/outputs.tf
# Outputs for the ECS module.
output "ecs_cluster_name" {
  description = "The name of the ECS cluster."
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "The name of the ECS service."
  value       = aws_ecs_service.nginx_app_service.name
}

output "ecs_task_security_group_id" {
  description = "The ID of the ECS task security group."
  value       = aws_security_group.ecs_tasks.id
}
