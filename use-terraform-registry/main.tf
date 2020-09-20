terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "example-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-northeast-1a", "ap-northeast-1d", "ap-northeast-1d"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "web_server_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "web-server"
  description = "sg for http ingress"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}

data "aws_ami" "ubuntu-focal" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

data "template_file" "user_data" {
  template = file("user_data.yaml")
}

module "ec2_instances" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name           = "example-ec2-cluster"
  instance_count = 2

  ami                    = data.aws_ami.ubuntu-focal.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.vpc.default_security_group_id, module.web_server_sg.this_security_group_id]
  subnet_ids             = module.vpc.public_subnets
  #subnet_id              = module.vpc.public_subnets[0]

  user_data = data.template_file.user_data.rendered

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

