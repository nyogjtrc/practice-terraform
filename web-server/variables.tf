variable "aws_region" {
  type        = string
  description = "AWS region to launch servers."
  default     = "ap-northeast-1"
}

variable "cidr" {
  type        = string
  description = "vpc cidr block"
}

variable "public_subnet" {
  type        = string
  description = "public subnet cidr block"
}

variable "public_key_path" {
  type        = string
  description = "Path to SSH public key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "ami" {
  type        = string
  description = "ami id"
}

variable "my_ip" {
  type        = string
  description = "my ip to allow ssh connection"
}
