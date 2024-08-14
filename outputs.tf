# Output the EKS cluster endpoint and certificate authority data
output "eks_cluster_endpoint" {
  value = aws_eks_cluster.ledgerndary.endpoint
}

output "eks_cluster_certificate_authority" {
  value = aws_eks_cluster.ledgerndary.certificate_authority[0].data
  sensitive = true
}

output "eks_cluster_name" {
  value = aws_eks_cluster.ledgerndary.name
}

output "aws_vpc" {
  value = aws_vpc.main.cidr_block
}


# List Output
output "aws_subnets" {
  value = [
    aws_subnet.private-us-east-1a.cidr_block,
    aws_subnet.private-us-east-1b.cidr_block,
    aws_subnet.public-us-east-1a.cidr_block,
    aws_subnet.public-us-east-1b.cidr_block
  ]
}

# # Maps Output
# output "aws_subnets" {
#   value = {
#     "us-east-1a-private" = aws_subnet.private-us-east-1a.cidr_block,
#     "us-east-1b-private" = aws_subnet.private-us-east-1b.cidr_block,
#     "us-east-1a-public" = aws_subnet.public-us-east-1a.cidr_block,
#     "us-east-1b-public" = aws_subnet.public-us-east-1b.cidr_block
#   }
# }
