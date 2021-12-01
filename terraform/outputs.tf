# Output value definitions

output "aws_region" {
  description = "Deployed to AWS region"
  value = var.aws_region
}

output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."
  value = aws_s3_bucket.lambda_bucket.id
}

output "function_name" {
  description = "Name of the Lambda function that writes to DynamoDB."
  value = aws_lambda_function.write_data.function_name
}

output "api-gateway" {
  description = "Url of API Gateway."
  value = aws_apigatewayv2_stage.api_gw.invoke_url
}

output "cognito-user-pool-id" {
  description = "Id of cognito user pool"
  value = aws_cognito_user_pool.pool.id
}

output "cognito-app-client-id" {
  description = "Id of the app client"
  value = aws_cognito_user_pool_client.client.id
}