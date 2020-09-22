variable "bucket_name" {
  description = "the s3 bucket name."
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
