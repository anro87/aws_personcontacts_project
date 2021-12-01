# Define API
resource "aws_apigatewayv2_api" "api_gw" {
  name          = "serverless_lambda_gw"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["POST", "GET"]
    allow_headers = ["content-type","Authorization"]
  }
  tags = {
    Owner = "Andreas.Rotaru"
  }
}

# Define API-Authorization with Cognito JWT Token
resource "aws_apigatewayv2_authorizer" "api_gw_auth" {
  name             = "serverless_lambda_gw_auth"
  api_id           = aws_apigatewayv2_api.api_gw.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    audience = [aws_cognito_user_pool_client.client.id]
    issuer   = "https://${aws_cognito_user_pool.pool.endpoint}"
  }
}

# Define API-Stage
resource "aws_apigatewayv2_stage" "api_gw" {
  api_id = aws_apigatewayv2_api.api_gw.id

  name        = "serverless_lambda_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw_log_group.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

# Define AWS Integration between API-GW and Lambda
resource "aws_apigatewayv2_integration" "lambda_write" {
  api_id = aws_apigatewayv2_api.api_gw.id

  integration_uri    = aws_lambda_function.write_data.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

# Define AWS Integration between API-GW and Lambda
resource "aws_apigatewayv2_integration" "lambda_read" {
  api_id = aws_apigatewayv2_api.api_gw.id

  integration_uri    = aws_lambda_function.read_data.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

# Define API-Endpoint
resource "aws_apigatewayv2_route" "lambda_write" {
  api_id = aws_apigatewayv2_api.api_gw.id

  route_key = "POST /contact"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_write.id}"
  authorization_type = "JWT"
  authorizer_id = aws_apigatewayv2_authorizer.api_gw_auth.id
}

resource "aws_apigatewayv2_route" "lambda_read" {
  api_id = aws_apigatewayv2_api.api_gw.id

  route_key = "GET /contact"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_read.id}"
  authorization_type = "JWT"
  authorizer_id = aws_apigatewayv2_authorizer.api_gw_auth.id
}

# Define API-GW specific CloudWatch Log-Group
resource "aws_cloudwatch_log_group" "api_gw_log_group" {
  name              = "/aws/api_gw/lambda_api_gw"
  retention_in_days = 1
  tags = {
    Owner = "Andreas.Rotaru"
  }
}

# Give API-Gateway permission to call lambda
resource "aws_lambda_permission" "api_gw_lambda_write_data" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.write_data.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api_gw.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_gw_lambda_read_data" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.read_data.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api_gw.execution_arn}/*/*"
}