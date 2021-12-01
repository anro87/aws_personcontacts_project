resource "aws_lambda_function" "read_data" {
  function_name = "ReadLambdaData"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_bucket_object.read_lambda_data.key

  runtime = "java8"
  handler = "ReadDynamoDB"
  memory_size = 1024

  source_code_hash = base64sha256(var.read_lambda_jar)

  role = aws_iam_role.read_lambda_exec.arn

  tags = {
    Owner = "Andreas.Rotaru@bridging-it.de"
  }
}

resource "aws_cloudwatch_log_group" "read_lambda_log_group" {
  name = "/aws/lambda/${aws_lambda_function.read_data.function_name}"
  
  retention_in_days = 1
  tags = {
    Owner = "Andreas.Rotaru@bridging-it.de"
  }
}

# Make sure lambda can uplevel permissions by assumerole policy
resource "aws_iam_role" "read_lambda_exec" {
  name = "read_serverless_lambda"

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
    Owner = "Andreas.Rotaru@bridging-it.de"
  }
}

#Define inline policy
resource "aws_iam_role_policy" "read_lambda_dynamoDB_policy" {
  role = aws_iam_role.read_lambda_exec.name
  name = "DynamoDBLambdaDataReadAccess"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Action" : [
        "dynamodb:GetItem",
        "dynamodb:Query"
      ],
      "Resource" : aws_dynamodb_table.basic-dynamodb-table.arn
      }
    ]
  })
}

# Attach AWS Policy to Lambda
resource "aws_iam_role_policy_attachment" "read_lambda_policy" {
  role       = aws_iam_role.read_lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}