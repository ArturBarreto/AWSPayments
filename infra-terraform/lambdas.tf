# Package create_card Lambda
data "archive_file" "create_card_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../services/create_card"
  output_path = "${path.module}/create_card.zip"
}

resource "aws_lambda_function" "create_card" {
  function_name = "${local.project}-create-card"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "handler.handle"
  runtime       = "python3.13"
  filename      = data.archive_file.create_card_zip.output_path
  source_code_hash = data.archive_file.create_card_zip.output_base64sha256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.payments.name
    }
  }

  tracing_config { mode = "Active" }
  tags = local.tags
}

# Package get_card Lambda
data "archive_file" "get_card_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../services/get_card"
  output_path = "${path.module}/get_card.zip"
}

resource "aws_lambda_function" "get_card" {
  function_name = "${local.project}-get-card"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "handler.handle"
  runtime       = "python3.13"
  filename      = data.archive_file.get_card_zip.output_path
  source_code_hash = data.archive_file.get_card_zip.output_base64sha256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.payments.name
    }
  }

  tracing_config { mode = "Active" }
  tags = local.tags
}
