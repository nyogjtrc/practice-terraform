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

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.this.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_subnet" "this" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "sg for ssh incoming"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [format("%s/32", var.my_ip)]
  }
}

resource "aws_security_group" "web" {
  name        = "web"
  description = "sg for web incoming"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "practice" {
  key_name   = "practice"
  public_key = file(var.public_key_path)
}

data "aws_ami" "web" {
  filter {
    name   = "state"
    values = ["available"]
  }
  owners = ["self"]

  filter {
    name   = "name"
    values = ["packer-ubuntu-web-*"]
  }

  most_recent = true
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.web.id
  instance_type = "t2.micro"

  key_name = aws_key_pair.practice.id

  vpc_security_group_ids = [
    aws_security_group.ssh.id,
    aws_security_group.web.id,
  ]

  subnet_id = aws_subnet.this.id

  tags = {
    Name  = "web-packer-terraform"
    topic = "web-packer"
  }
}
