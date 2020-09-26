resource "aws_api_gateway_rest_api" "hello" {
  name        = "hello"
  description = "Serverless hello world"
}

resource "aws_api_gateway_resource" "hello" {
  path_part   = "hello"
  parent_id   = aws_api_gateway_rest_api.hello.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.hello.id
}

resource "aws_api_gateway_method" "hello" {
  rest_api_id   = aws_api_gateway_rest_api.hello.id
  resource_id   = aws_api_gateway_resource.hello.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "hello" {
  rest_api_id             = aws_api_gateway_rest_api.hello.id
  resource_id             = aws_api_gateway_resource.hello.id
  http_method             = aws_api_gateway_method.hello.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.hello.invoke_arn
}

resource "aws_api_gateway_deployment" "hello_v1" {
  depends_on = [
    aws_api_gateway_integration.hello
  ]
  rest_api_id = aws_api_gateway_rest_api.hello.id
  stage_name  = "v1"
}


resource "aws_lambda_permission" "hello" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello.arn
  principal     = "apigateway.amazonaws.com"
}

