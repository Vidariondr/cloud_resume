resource "aws_apigatewayv2_api" "visitor_counter_api" {
  disable_execute_api_endpoint = true
  ip_address_type              = "dualstack"
  name                         = "visitor_counter_api"
  protocol_type                = "HTTP"
  cors_configuration {
    allow_origins = ["https://${var.domain}"]
    max_age       = 3600
  }
}

resource "aws_apigatewayv2_integration" "visitor_counter_api" {
  api_id                 = aws_apigatewayv2_api.visitor_counter_api.id
  integration_method     = "POST"
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.visitor_counter_function.arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "visitor_counter_api" {
  api_id    = aws_apigatewayv2_api.visitor_counter_api.id
  route_key = "ANY /visitors"
  target    = "integrations/${aws_apigatewayv2_integration.visitor_counter_api.id}"
}

resource "aws_lambda_permission" "api_gateway" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.visitor_counter_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.visitor_counter_api.execution_arn}/*/*/visitors"
  statement_id  = "AllowExecutionFromAPIGateway"
}

resource "aws_apigatewayv2_domain_name" "api_gateway_domain" {
  domain_name = "api.${var.domain}"

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.api_domain.arn
    endpoint_type   = "REGIONAL"
    ip_address_type = "dualstack"
    security_policy = "TLS_1_2"
  }
}