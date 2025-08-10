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
  filename            = data.archive_file.create_card_zip.output_path
  source_code_hash = base64sha256("${data.archive_file.create_card_zip.output_base64sha256}${var.code_version}"
)

  environment {
    variables = {
      TABLE_NAME   = aws_dynamodb_table.payments.name
      CODE_VERSION = var.code_version
    }
  }

  tracing_config { mode = "Active" }

  # ✅ ensure IAM is ready before Lambda
  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_iam_role_policy_attachment.lambda_ddb_rw,
    aws_iam_role_policy_attachment.lambda_xray
  ]

  timeouts {
    create = "10m"
    update = "10m"
  }

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
  filename         = data.archive_file.get_card_zip.output_path
  source_code_hash = base64sha256("${data.archive_file.get_card_zip.output_base64sha256}${var.code_version}"
)

  environment {
    variables = {
      TABLE_NAME   = aws_dynamodb_table.payments.name
      CODE_VERSION = var.code_version
    }
  }

  tracing_config { mode = "Active" }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_iam_role_policy_attachment.lambda_ddb_rw,
    aws_iam_role_policy_attachment.lambda_xray
  ]

  timeouts {
    create = "10m"
    update = "10m"
  }

  tags = local.tags
}
