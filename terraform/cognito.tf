resource "aws_cognito_user_pool" "pool" {
  name = "anro_app_pool"
  password_policy {
    minimum_length = "8"
  }
  username_attributes = ["email"]
  auto_verified_attributes = ["email"]
}

resource "aws_cognito_user_pool_client" "client" {
  name         = "myclient"
  user_pool_id = aws_cognito_user_pool.pool.id
  # allowed_oauth_flows = ["implicit"]
  # allowed_oauth_scopes = ["email"]
}
