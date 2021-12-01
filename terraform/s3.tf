resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = var.s3_lambda_bucket
  acl           = "private"
  force_destroy = true
  tags = {
    Owner = "Andreas.Rotaru"
  }
}

# Add write lambda coding to s3 (JavaScript coding)
data "archive_file" "write_lambda_data" {
  type = "zip"

  source_dir  = "${path.module}/../lambdas/writeDynamoDB"
  output_path = "${path.module}/../write_lambda_data.zip"
}

resource "aws_s3_bucket_object" "write_lambda_data" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "write_lambda_data.zip"
  source = data.archive_file.write_lambda_data.output_path

  etag = filemd5(data.archive_file.write_lambda_data.output_path)
}

# Add read lambda coding to s3 (Java coding)
resource "aws_s3_bucket_object" "read_lambda_data" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "read_lambda_data.jar"
  source = var.read_lambda_jar

  etag = filemd5(var.read_lambda_jar)
}