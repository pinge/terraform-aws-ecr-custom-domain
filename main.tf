data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "archive_file" "this" {
  source_file = "${path.module}/dist/index.js"
  output_path = "${path.module}/dist/package.zip"
  type        = "zip"
}

locals {
  account_id  = data.aws_caller_identity.current.account_id
  region      = coalesce(var.region, data.aws_region.current.name)
  lambda_name = coalesce(var.lambda_name, "ecr-facade-${replace(var.domain_name, ".", "-")}")
}

resource "aws_acm_certificate" "this" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "certificate_validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  zone_id         = var.zone_id
  ttl             = 60
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate_validation : record.fqdn]
}

resource "aws_apigatewayv2_api" "this" {
  name                         = "ECR Facade API - ${var.domain_name}"
  protocol_type                = "HTTP"
  disable_execute_api_endpoint = true
  depends_on                   = [aws_acm_certificate_validation.this]
}

resource "aws_apigatewayv2_domain_name" "this" {
  domain_name = var.domain_name

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.this.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  depends_on = [aws_acm_certificate_validation.this]
}

resource "aws_apigatewayv2_stage" "this" {
  name        = "$default"
  api_id      = aws_apigatewayv2_api.this.id
  auto_deploy = true
}

resource "aws_apigatewayv2_api_mapping" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  domain_name = aws_apigatewayv2_domain_name.this.domain_name
  stage       = aws_apigatewayv2_stage.this.name
}

resource "aws_route53_record" "this" {
  for_each       = toset(["A", "AAAA"])
  name           = aws_apigatewayv2_domain_name.this.domain_name
  set_identifier = local.region
  type           = each.key
  zone_id        = var.zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_apigatewayv2_domain_name.this.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.this.domain_name_configuration[0].hosted_zone_id
  }

  latency_routing_policy {
    region = local.region
  }
}

resource "aws_iam_role" "this" {
  name = "${local.lambda_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = {
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = {
        Service = [
          "edgelambda.amazonaws.com",
          "lambda.amazonaws.com",
        ]
      }
    }
  })
}

resource "aws_lambda_function" "this" {
  provider         = aws
  filename         = data.archive_file.this.output_path
  function_name    = local.lambda_name
  role             = aws_iam_role.this.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.this.output_base64sha256
  runtime          = "nodejs18.x"
  environment {
    variables = { AWS_ECR_PATH = "${local.account_id}.dkr.ecr.${local.region}.amazonaws.com" }
  }
}

resource "aws_apigatewayv2_integration" "this" {
  api_id                 = aws_apigatewayv2_api.this.id
  integration_method     = "POST"
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.this.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "this" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.this.id}"
}

resource "aws_lambda_permission" "this" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.this.execution_arn}/$default/ANY/{proxy+}"
}
