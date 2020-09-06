terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.5.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "ap-northeast-1"
}

resource "aws_instance" "example" {
  # Ubuntu Server 20.04 LTS (HVM), SSD Volume Type, 64-bit x86
  ami           = "ami-0461b11e2fad8c14a"
  instance_type = "t2.micro"
}
