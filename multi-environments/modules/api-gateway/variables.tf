variable "api_name" {
  type = string
}

variable "path_part" {
  type = string
}

variable "http_method" {
  type = string
}

variable "lambda_invoke_arn" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
