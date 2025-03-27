terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">=1.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_cognito_user_pool" "fastfood_pool" {
  name = "fastfood-user-pool"

  # Vamos usar e-mail como nome de usuário
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length = 6
    require_lowercase = false
    require_numbers   = false
    require_symbols   = false
    require_uppercase = false
    temporary_password_validity_days = 7
  }

  # Exemplo de atributo custom (CPF) se você quiser
  schema {
    attribute_data_type = "String"
    name                = "cpf"
    required            = false
    mutable             = true
  }

  mfa_configuration = "OFF"
}

resource "aws_cognito_user_pool_client" "fastfood_pool_client" {
  name         = "fastfood-user-pool-client"
  user_pool_id = aws_cognito_user_pool.fastfood_pool.id

  allowed_oauth_flows       = ["code"]
  allowed_oauth_scopes      = ["email", "openid", "profile"]
  allowed_oauth_flows_user_pool_client = true

  generate_secret = false
  callback_urls   = ["http://localhost:3000/callback"]
  logout_urls     = ["http://localhost:3000/logout"]

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_CUSTOM_AUTH"
  ]

  supported_identity_providers = ["COGNITO"]

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }
  access_token_validity  = 60
  id_token_validity      = 60
  refresh_token_validity = 30
}