# IAM Role for AWS Load Balancer Controller
resource "aws_iam_role" "aws_load_balancer_controller" {
  name = "AWSLoadBalancerControllerRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = data.terraform_remote_state.infra.outputs.oidc_provider_arn
        }
        Condition = {
          StringEquals = {
            "${replace(data.terraform_remote_state.infra.outputs.oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
            "${replace(data.terraform_remote_state.infra.outputs.oidc_issuer_url, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = var.tags
}

# Attach the AWS Load Balancer Controller IAM Policy
resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller" {
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/AWSLoadBalancerControllerIAMPolicy"
  role       = aws_iam_role.aws_load_balancer_controller.name
}

# Data source to get current AWS account ID
data "aws_caller_identity" "current" {}

# Kubernetes Service Account
resource "kubernetes_service_account" "aws_load_balancer_controller" {
  
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.aws_load_balancer_controller.arn
    }
  }

  /*depends_on = [
    aws_eks_access_policy_association.admin
  ]*/
}

resource "helm_release" "aws_load_balancer_controller" {

  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  set = [ 
    {
      name  = "clusterName"
      value = data.terraform_remote_state.infra.outputs.aws_eks_cluster
    },
    {
    name  = "vpcId"
    value = local.vpc_id
    },
    {
      name  = "serviceAccount.create"
      value = "false"
    },
    {
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
    }
  ]

  depends_on = [ 
    kubernetes_service_account.aws_load_balancer_controller 
  ]

}