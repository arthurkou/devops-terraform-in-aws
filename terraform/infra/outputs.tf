output "internet_gateway_id" {
  value = aws_internet_gateway.this.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.this.id
}

output "private_subnets_arn" {
  value = aws_subnet.private[*].arn
}

output "public_subnets_arn" {
  value = aws_subnet.public[*].arn
}

output "oidc_issuer_url" {
  value = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
}

output "aws_eks_cluster" {
  value = aws_eks_cluster.this.name
}

output "vpc_id" {
  value = aws_vpc.this.id
}
