output "certificate_arn" {
  value = aws_acm_certificate.this.arn
}

output "records" {
  value = aws_route53_record.this.*
}

output "api_gateway_arn" {
  value = aws_apigatewayv2_api.this.arn
}

output "aws_lambda_function_arn" {
  value = aws_lambda_function.this.arn
}
