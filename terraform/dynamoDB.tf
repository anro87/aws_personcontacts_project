resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "LambdaDataPush"
  billing_mode   = "PROVISIONED"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "userid"
  range_key      = "contactid"

  attribute {
    name = "userid"
    type = "S"
  }

  attribute {
    name = "contactid"
    type = "S"
  }

  tags = {
    Owner = "Andreas.Rotaru"
  }
}