resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "s3_oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_cache_policy" "cache_policy" {
  default_ttl = 86400
  comment     = "Policy with caching enabled. Supports Gzip and Brotli compression."
  max_ttl     = 31536000
  min_ttl     = 1
  name        = "Managed-CachingOptimized"
  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  aliases             = [var.domain]
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  price_class         = "PriceClass_All"
  wait_for_deployment = true

  origin {
    domain_name              = aws_s3_bucket.website.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
    origin_id                = var.s3_origin_name
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cache_policy_id        = aws_cloudfront_cache_policy.cache_policy.id
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.s3_origin_name
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = data.aws_acm_certificate.main_certificate.arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
    cloudfront_default_certificate = false
  }
}