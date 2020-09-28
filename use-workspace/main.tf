terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "ap-northeast-1"
}

variable "instance_type" {
  type = string
}

resource "aws_instance" "example" {
  # Ubuntu Server 20.04 LTS (HVM), SSD Volume Type, 64-bit x86
  ami           = "ami-0461b11e2fad8c14a"
  instance_type = var.instance_type

  tags = {
    Name        = "web - ${terraform.workspace}"
    Terraform   = "true"
    Environment = terraform.workspace
  }
}

output "instance_type" {
  value = aws_instance.example.instance_type
}

output "instance_name" {
  value = aws_instance.example.tags.Name
}
