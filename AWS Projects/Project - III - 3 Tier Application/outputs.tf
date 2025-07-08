# Public IPs of Web-srv-I & Web-srv-II
output "web_public_ips" {
  description = "Public IPs of Web-srv-I & II"
  value       = aws_instance.web[*].public_ip
}

# Private IPs of App-srv-I & App-srv-II
output "app_private_ips" {
  description = "Private IPs of App-srv-I & II"
  value       = aws_instance.app[*].private_ip
}

# RDS Endpoint
output "rds_endpoint" {
  description = "RDS MySQL endpoint"
  value       = aws_db_instance.rds.address
}

# RDS Port
output "rds_port" {
  description = "RDS MySQL port"
  value       = aws_db_instance.rds.port
}