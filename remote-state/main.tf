provider "aws" {
  profile = "default"
  region  = "ap-northeast-1"
}


resource "aws_s3_bucket" "state" {
  bucket_prefix = "terraform-state"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Terraform = true
  }
}

resource "aws_dynamodb_table" "state_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Terraform = true
  }
}
