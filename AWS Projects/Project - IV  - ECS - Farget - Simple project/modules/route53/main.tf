# modules/route53/main.tf
# Defines the Route 53 public hosted zone and A record.
resource "aws_route53_zone" "main_public_hosted_zone" {
  name = var.domain_name

  tags = {
    Name        = "${var.project_name}-public-hosted-zone"
    Environment = "FreeTier"
  }
}

resource "aws_route53_record" "www_alias" {
  zone_id = aws_route53_zone.main_public_hosted_zone.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }

}


