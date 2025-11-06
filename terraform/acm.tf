resource "aws_acm_certificate" "main_domain" {
  provider = aws.us-east

  domain_name       = var.domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "api_domain" {
  domain_name       = "api.${var.domain}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_acm_certificate" "main_certificate" {
  provider = aws.us-east

  domain      = var.domain
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_acm_certificate" "api_certificate" {
  domain      = "api.${var.domain}"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}