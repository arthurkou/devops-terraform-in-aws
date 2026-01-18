terraform {
  //keep tf state in bucket - remote backend
  backend "s3" {
    bucket       = "devops-na-nuvem-remote-backend-bucket"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    //dynamodb_table = "devops-na-nuvem-remote-backend-table"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.assume_role.region

  assume_role {
    role_arn = var.assume_role.role_arn
  }

  default_tags {
    tags = var.tags
  }
}