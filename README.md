# AWS ECR custom domain Terraform module

Terraform module to provision a custom domain for AWS ECR.

## Usage

```hcl
module "aws_ecr_custom_domain" {
  source      = "pinge/terraform-aws-ecr-custom-domain"
  domain_name = "ecr.example.com"
  zone_id = aws_route53_zone.some_zone.id

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
```

## Why

AWS ECR [does not support custom domain names](https://github.com/aws/containers-roadmap/issues/299). This module provisions a custom domain for your container registry so you don't have to deal with a `987654321.dkr.ecr.eu-east-1.amazonaws.com` registry path.

## How

When running `docker pull` the Docker Registry [returns 307 Temporary Redirects](https://httptoolkit.com/blog/docker-image-registry-facade/) to the actual image content.

This module creates a "registry facade" on the custom domain by provisioning an API Gateway that returns a `307 Temporary Redirect` when executing `docker pull` or `docker push`.

For `docker pull/push` to work, you will need to authenticate with `docker login ecr.example.com`

## Examples

- [Complete](https://github.com/pinge/terraform-aws-ecr-custom-domain/tree/main/examples/complete)

## Contributing

Report issues/questions/feature requests on in the [issues](https://github.com/pinge/terraform-aws-ecr-custom-domain/issues/new) section.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | >= 2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | >= 2.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_apigatewayv2_api.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api) | resource |
| [aws_apigatewayv2_api_mapping.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api_mapping) | resource |
| [aws_apigatewayv2_domain_name.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_domain_name) | resource |
| [aws_apigatewayv2_integration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration) | resource |
| [aws_apigatewayv2_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_route) | resource |
| [aws_apigatewayv2_stage.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_stage) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_route53_record.certificate_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [archive_file.this](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The custom domain for AWS ECR | `string` | n/a | yes |
| <a name="input_lambda_name"></a> [lambda\_name](#input\_lambda\_name) | The name of the Lambda function | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | The default AWS region | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | The AWS Route 53 zone id of the ECR custom domain | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_gateway_arn"></a> [api\_gateway\_arn](#output\_api\_gateway\_arn) | n/a |
| <a name="output_aws_lambda_function_arn"></a> [aws\_lambda\_function\_arn](#output\_aws\_lambda\_function\_arn) | n/a |
| <a name="output_certificate_arn"></a> [certificate\_arn](#output\_certificate\_arn) | n/a |
| <a name="output_records"></a> [records](#output\_records) | n/a |
<!-- END_TF_DOCS -->

## Authors

This Terraform module is maintained by [Nuno Pinge](https://github.com/pinge).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/pinge/terraform-aws-ecr-custom-domain/tree/main/LICENSE) for full details.
