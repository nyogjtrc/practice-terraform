terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "ap-northeast-1"
}

provider "archive" {}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "bin/main"
  output_path = "hello_lambda.zip"
}

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

resource "aws_iam_role" "lambda_exec" {
  name               = "lambda_exec"
  assume_role_policy = data.aws_iam_policy_document.policy.json
}

resource "aws_lambda_function" "hello" {
  function_name    = "hello_lambda"
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256

  role    = aws_iam_role.lambda_exec.arn
  handler = "main"
  runtime = "go1.x"
}

