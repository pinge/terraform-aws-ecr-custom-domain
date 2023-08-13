provider "aws" {
  region = local.region
}

locals {
  region      = "us-east-1"
  domain_name = "ecr.example.com"
  lambda_name = "ecrFacade"

  tags = {
    Terraform   = "true"
    Environment = "production"
  }
}

resource "aws_route53_zone" "example" {
  name = "example.com"
  tags = merge({ Name = "example-com-zone" }, local.tags)
}

module "aws_ecr_custom_domain" {
  source      = "../../"
  domain_name = local.domain_name
  lambda_name = local.lambda_name
  region      = local.region
  zone_id     = aws_route53_zone.example.id
  tags        = local.tags
}
