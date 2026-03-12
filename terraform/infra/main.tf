terraform {
  //keep tf state in bucket - remote backend
  backend "s3" {
    bucket       = "devops-na-nuvem-remote-backend-bucket"
    key          = "infra/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    //dynamodb_table = "devops-na-nuvem-remote-backend-table"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
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

/*provider "kubernetes" {
  host = aws_eks_cluster.this.endpoint

  cluster_ca_certificate = base64decode(
    aws_eks_cluster.this.certificate_authority[0].data
  )

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"

    args = [
      "eks",
      "get-token",
      "--cluster-name",
      aws_eks_cluster.this.name
    ]
  }*/
