variable "aws_region" {
  type        = string
  description = "AWS region to launch servers."
  default     = "ap-northeast-1"
}

variable "public_key_path" {
  type        = string
  description = "Path to SSH public key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  type        = string
  description = "Path to SSH private key"
  default     = "~/.ssh/id_rsa"
}

variable "my_ip" {
  type        = string
  description = "my ip to allow ssh connection"
}
