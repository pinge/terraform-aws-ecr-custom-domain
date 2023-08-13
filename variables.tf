variable "domain_name" {
  type        = string
  description = "The custom domain for AWS ECR"
}

variable "lambda_name" {
  type        = string
  description = "The name of the Lambda function"
  default     = null
}

variable "region" {
  type        = string
  description = "The default AWS region"
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "zone_id" {
  type        = string
  description = "The AWS Route 53 zone id of the ECR custom domain"
}
