terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "../code/bin/main"
  output_path = "lambda_source.zip"
}

module "lambda_go" {
  source = "../modules/lambda-go"

  lambda_role_name = "lambda_prod"
  function_name    = "hello_prod"
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256

  handler = "main"

  tags = {
    Terraform   = "true"
    Environment = "prod"
  }
}

module "api" {
  source = "../modules/api-gateway"

  api_name          = "hello"
  path_part         = "hello"
  http_method       = "GET"
  lambda_invoke_arn = module.lambda_go.invoke_arn

  tags = {
    Terraform   = "true"
    Environment = "prod"
  }
}
