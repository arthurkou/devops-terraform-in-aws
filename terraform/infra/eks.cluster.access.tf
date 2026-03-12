resource "aws_eks_access_entry" "users" {
  for_each = toset(var.granted_arn_users)

  cluster_name  = var.eks_cluster.name
  principal_arn = each.value
  type          = "STANDARD"

  depends_on = [
    aws_eks_cluster.this
  ]
}

resource "aws_eks_access_entry" "roles" {
  for_each = toset(var.granted_arn_roles)

  cluster_name  = var.eks_cluster.name
  principal_arn = each.value
  type          = "STANDARD"

  depends_on = [
    aws_eks_cluster.this,
    aws_eks_node_group.this
  ]
}

resource "aws_eks_access_policy_association" "admin" {
  for_each = merge(
    aws_eks_access_entry.roles,
    aws_eks_access_entry.users
  )

  cluster_name  = var.eks_cluster.name
  principal_arn = each.value.principal_arn
  policy_arn    = var.eks_cluster.policy_arn_access

  access_scope {
    type = "cluster"
  }
}
