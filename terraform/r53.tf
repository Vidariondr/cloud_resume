resource "aws_route53_zone" "main_domain" {
  name = var.domain
}

resource "aws_route53_record" "cloudfront_a" {
  name    = var.domain
  type    = "A"
  zone_id = aws_route53_zone.main_domain.zone_id
  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
  }
}

resource "aws_route53_record" "cloudfront_aaaa" {
  name    = var.domain
  type    = "AAAA"
  zone_id = aws_route53_zone.main_domain.zone_id
  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
  }
}

resource "aws_route53_record" "api_a" {
  name    = "api.${var.domain}"
  type    = "A"
  zone_id = aws_route53_zone.main_domain.zone_id
  alias {
    evaluate_target_health = true
    name                   = aws_apigatewayv2_domain_name.api_gateway_domain.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.api_gateway_domain.domain_name_configuration[0].hosted_zone_id
  }
}

resource "aws_route53_record" "api_aaaa" {
  name    = "api.${var.domain}"
  type    = "AAAA"
  zone_id = aws_route53_zone.main_domain.zone_id
  alias {
    evaluate_target_health = true
    name                   = aws_apigatewayv2_domain_name.api_gateway_domain.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.api_gateway_domain.domain_name_configuration[0].hosted_zone_id
  }
}