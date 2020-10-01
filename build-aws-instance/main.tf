terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    encrypt        = true
    bucket         = "terraform-state20200929152923719000000001"
    key            = "build-instance/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-locks"
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
