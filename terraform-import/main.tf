provider "aws" {
  profile = "default"
  region  = "ap-northeast-1"
}

resource "aws_instance" "web" {
}
