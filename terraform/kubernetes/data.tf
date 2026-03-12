data "terraform_remote_state" "infra" {
  backend = "s3"

  config = {
    bucket = "devops-na-nuvem-remote-backend-bucket"
    key    = "infra/terraform.tfstate" //  infra/terraform.tfstate
    region = "us-east-1"
  }
}

data "aws_eks_cluster" "this" {
  name = data.terraform_remote_state.infra.outputs.aws_eks_cluster
}

locals {
  cluster_name       = data.terraform_remote_state.infra.outputs.aws_eks_cluster
  vpc_id             = data.terraform_remote_state.infra.outputs.vpc_id
  public_subnets     = data.terraform_remote_state.infra.outputs.public_subnets_arn
  private_subnets    = data.terraform_remote_state.infra.outputs.private_subnets_arn
}