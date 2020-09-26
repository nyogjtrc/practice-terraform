output "lambda" {
  value = aws_lambda_function.hello.qualified_arn
}

output "url" {
  value = "${aws_api_gateway_deployment.hello_v1.invoke_url}${aws_api_gateway_resource.hello.path}"
}
