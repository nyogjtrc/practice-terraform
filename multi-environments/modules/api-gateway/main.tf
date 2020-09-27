resource "aws_api_gateway_rest_api" "this" {
  name        = var.api_name
  description = "Serverless api gateway"

  tags = var.tags
}

resource "aws_api_gateway_resource" "this" {
  path_part   = var.path_part
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_method" "this" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.this.id
  http_method   = var.http_method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "this" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.this.id
  http_method             = aws_api_gateway_method.this.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

resource "aws_api_gateway_deployment" "this" {
  depends_on = [
    aws_api_gateway_integration.this
  ]
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = "v1"
}

