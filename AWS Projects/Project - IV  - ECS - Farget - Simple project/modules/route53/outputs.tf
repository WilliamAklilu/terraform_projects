# modules/route53/outputs.tf
# Outputs for the Route 53 module.
output "hosted_zone_name" {
  description = "The name of the Route 53 public hosted zone."
  value       = aws_route53_zone.main_public_hosted_zone.name
}

output "record_name" {
  description = "The name of the Route 53 A record."
  value       = aws_route53_record.www_alias.name
}