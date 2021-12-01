locals {
  aws_region    = "eu-central-1"
  s3_www_bucket = "anro-webpage-bucket"
}

module "aws_webpage" {
  source        = "./terraform/"
  aws_region    = local.aws_region
  s3_www_bucket = local.s3_www_bucket
}

output "aws_region" {
  description = "Deployed to AWS region."
  value       = module.aws_webpage.aws_region
}

output "bucket_domain_name" {
  description = "S3 webpage."
  value       = module.aws_webpage.bucket_domain_name
}