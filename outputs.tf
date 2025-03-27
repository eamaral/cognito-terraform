output "user_pool_id" {
  description = "ID do User Pool Cognito"
  value       = aws_cognito_user_pool.fastfood_pool.id
}

output "user_pool_client_id" {
  description = "ID do App Client do Cognito"
  value       = aws_cognito_user_pool_client.fastfood_pool_client.id
}