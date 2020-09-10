variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "ap-northeast-1"
}

variable "cidr" {
  description = "vpc cidr block"
}

variable "public_subnet" {
  description = "public subnet cidr block"
}

variable "public_key_path" {
  description = "Path to SSH public key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "ami" {
  description = "ami id, default as Ubuntu Server 20.04 LTS (HVM), SSD Volume Type, 64-bit x86"
}

variable "my_ip" {
  description = "my ip to allow ssh connection"
}
