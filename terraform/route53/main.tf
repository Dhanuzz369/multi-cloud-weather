terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "primary_ip" {}
variable "secondary_ip" {}

resource "aws_route53_health_check" "primary_health" {
  fqdn              = var.primary_ip
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 30
}

resource "aws_route53_record" "failover_record" {
  zone_id = "YOUR_HOSTED_ZONE_ID"
  name    = "weatherportal.yourdomain.com"
  type    = "A"

  set_identifier = "primary-aws"
  failover_routing_policy {
    type = "PRIMARY"
  }

  ttl             = 60
  records         = [var.primary_ip]
  health_check_id = aws_route53_health_check.primary_health.id
}

resource "aws_route53_record" "failover_secondary" {
  zone_id = "YOUR_HOSTED_ZONE_ID"
  name    = "weatherportal.yourdomain.com"
  type    = "A"

  set_identifier = "secondary-azure"
  failover_routing_policy {
    type = "SECONDARY"
  }

  ttl     = 60
  records = [var.secondary_ip]
}