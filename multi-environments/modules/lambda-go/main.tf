data "aws_iam_policy_document" "policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "this" {
  name               = var.lambda_role_name
  assume_role_policy = data.aws_iam_policy_document.policy.json
}

resource "aws_lambda_function" "this" {
  function_name    = var.function_name
  filename         = var.filename
  source_code_hash = var.source_code_hash

  role    = aws_iam_role.this.arn
  handler = var.handler
  runtime = "go1.x"

  tags = var.tags
}

resource "aws_lambda_permission" "this" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.arn
  principal     = "apigateway.amazonaws.com"
}

