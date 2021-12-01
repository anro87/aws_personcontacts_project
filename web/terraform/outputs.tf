# Output value definitions

output "aws_region" {
  description = "Deployed to AWS region"
  value = var.aws_region
}

output "bucket_domain_name" {
  value = aws_s3_bucket.s3_www_bucket.website_endpoint
}