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

  lambda_role_name = "lambda_dev"
  function_name    = "hello_dev"
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256

  handler = "main"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "api" {
  source = "../modules/api-gateway"

  api_name          = "hello_dev"
  path_part         = "hello_dev"
  http_method       = "GET"
  lambda_invoke_arn = module.lambda_go.invoke_arn

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
