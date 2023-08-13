# Complete AWS ECR custom domain

The Terraform configuration in this folder provisions a set of resources for a domain alias to AWS ECR.

For the example to be provisioned correctly, you'll need to update `example.com` to a domain that you own and that is managed by Route 53.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which can cost money (API Gateway, for example). Run `terraform destroy` when you don't need these resources anymore.

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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.12.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_ecr_custom_domain"></a> [aws\_ecr\_custom\_domain](#module\_aws\_ecr\_custom\_domain) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_route53_zone.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
