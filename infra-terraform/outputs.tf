output "api_url" {
  description = "HTTP API base URL"
  value       = aws_apigatewayv2_stage.default.invoke_url
}

output "table_name" {
  value = aws_dynamodb_table.payments.name
}
