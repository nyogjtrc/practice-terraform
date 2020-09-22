provider "aws" {
  region = "ap-northeast-1"
}

module "website_bucket" {
  source = "./modules/static-s3-bucket"

  bucket_name = "terraform-practice-write-module"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
