resource "aws_apigatewayv2_api" "http_api" {
  name          = "${local.project}-http-api"
  protocol_type = "HTTP"
  cors_configuration {
    allow_headers = ["*"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }
  tags = local.tags
}

# Integrations
resource "aws_apigatewayv2_integration" "create_card" {
  api_id                 = aws_apigatewayv2_api.http_api.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.create_card.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "get_card" {
  api_id                 = aws_apigatewayv2_api.http_api.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.get_card.invoke_arn
  payload_format_version = "2.0"
}

# Routes
resource "aws_apigatewayv2_route" "post_cards" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /cards"
  target    = "integrations/${aws_apigatewayv2_integration.create_card.id}"
}

resource "aws_apigatewayv2_route" "get_card" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /cards/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.get_card.id}"
}

# Stage ($default auto-deploy)
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
  tags        = local.tags
}

# Permissions for API to call Lambda
resource "aws_lambda_permission" "apigw_create_card" {
  statement_id  = "AllowAPIGatewayInvokeCreateCard"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_card.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_get_card" {
  statement_id  = "AllowAPIGatewayInvokeGetCard"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_card.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}
