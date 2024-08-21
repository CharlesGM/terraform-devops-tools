provider "kubernetes" {
  alias                  = "ingress_nginx"
  host                   = aws_eks_cluster.ledgerndary.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.ledgerndary.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.ledgerndary_ingress_nginx.token
}

provider "helm" {
  alias = "ingress_nginx"
  kubernetes {
    host                   = aws_eks_cluster.ledgerndary.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.ledgerndary.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.ledgerndary_ingress_nginx.token
  }
}

data "aws_eks_cluster_auth" "ledgerndary_ingress_nginx" {
  name = aws_eks_cluster.ledgerndary.name
}

# Create the ingress-nginx namespace
resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"
  }
}

# Deploy ingress-nginx using Helm
resource "helm_release" "ingress_nginx" {
  name      = "ingress-nginx"
  namespace = kubernetes_namespace.ingress_nginx.metadata[0].name

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.10.2" # Adjust to the version you want to deploy

  create_namespace = false # Namespace is already created by the kubernetes_namespace resource

  # Load values from a file (if you have specific configurations)
  values = [
    file("${path.module}/ingress-nginx-values.yaml")
  ]

  depends_on = [kubernetes_namespace.ingress_nginx] # Ensure namespace is created first
  timeout    = 900
}
  