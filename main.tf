locals {
    aws_region = "eu-central-1"
    s3_lambda_bucket = "lambda-bucket-anro"
    lambda= "lambda-anro"
    read_lambda_jar = "${path.module}/lambdas/readDynamoDB/target/readDynamoDB-1.0-SNAPSHOT.jar"
}


module "aws_lambda_api_gateway" {
  source = "./terraform/"
  aws_region = local.aws_region
  s3_lambda_bucket = local.s3_lambda_bucket
  lambda = local.lambda
  read_lambda_jar = local.read_lambda_jar
}

output "aws_region"{
  description = "Deployed to AWS region."
  value = "${module.aws_lambda_api_gateway.aws_region}"
}

output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."
  value = "${module.aws_lambda_api_gateway.lambda_bucket_name}"
}

output "function_name" {
  description = "Name of the Lambda function that writes to DynamoDB."
  value = "${module.aws_lambda_api_gateway.function_name}"
}

output "api-gateway" {
  description = "Url of API Gateway."
  value = "${module.aws_lambda_api_gateway.api-gateway}"
}

output "cognito-user-pool-id" {
  description = "Cognito UserPool Id."
  value = "${module.aws_lambda_api_gateway.cognito-user-pool-id}"
}

output "cognito-app-client-id" {
  description = "Id of the app client"
  value = "${module.aws_lambda_api_gateway.cognito-app-client-id}"
}