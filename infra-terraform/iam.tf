# Execution role used by Lambdas
resource "aws_iam_role" "lambda_exec" {
  name = "${local.project}-${local.env}-lambda-exec"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
  tags = local.tags
}

# Basic logging
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# DynamoDB access
resource "aws_iam_policy" "ddb_rw" {
  name        = "${local.project}-${local.env}-ddb-rw"
  description = "DynamoDB R/W for payments table"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["dynamodb:*"],
      Resource = [
        aws_dynamodb_table.payments.arn,
        "${aws_dynamodb_table.payments.arn}/index/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_ddb_rw" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.ddb_rw.arn
}

# X-Ray tracing
resource "aws_iam_role_policy_attachment" "lambda_xray" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}
