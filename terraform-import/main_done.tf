provider "aws" {
  profile = "default"
  region  = "ap-northeast-1"
}

resource "aws_instance" "web" {
  ami           = "ami-05484c96f4ac5493e"
  instance_type = "t2.micro"

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  tags = {
    "Name"  = "web-packer-terraform"
    "topic" = "web-packer"
  }
}
