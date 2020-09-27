variable "lambda_role_name" {
  type = string
}

variable "function_name" {
  type = string
}

variable "filename" {
  type = string
}

variable "source_code_hash" {
  type = string
}

variable "handler" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
