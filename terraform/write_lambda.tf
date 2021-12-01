resource "aws_lambda_function" "write_data" {
  function_name = "PushLambdaData"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_bucket_object.write_lambda_data.key

  runtime = "nodejs12.x"
  handler = "writeDynamoDB.handler"

  source_code_hash = data.archive_file.write_lambda_data.output_base64sha256

  role = aws_iam_role.lambda_exec.arn

  tags = {
    Owner = "Andreas.Rotaru"
  }
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name = "/aws/lambda/${aws_lambda_function.write_data.function_name}"
  
  retention_in_days = 1
  tags = {
    Owner = "Andreas.Rotaru"
  }
}

# Make sure lambda can uplevel permissions by assumerole policy
resource "aws_iam_role" "lambda_exec" {
  name = "write_serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })

  tags = {
    Owner = "Andreas.Rotaru"
  }
}

#Define inline policy
resource "aws_iam_role_policy" "lambda_dynamoDB_policy" {
  role = aws_iam_role.lambda_exec.name
  name = "DynamoDBLambdaDataPushAccess"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Action" : [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem"
      ],
      "Resource" : aws_dynamodb_table.basic-dynamodb-table.arn
      }
    ]
  })
}

# Attach AWS Policy to Lambda
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}