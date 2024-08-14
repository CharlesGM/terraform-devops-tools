provider "kubernetes" {
  alias                  = "keycloak"
  host                   = aws_eks_cluster.ledgerndary.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.ledgerndary.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.ledgerndary_keycloak.token
}

provider "helm" {
  alias = "keycloak"
  kubernetes {
    host                   = aws_eks_cluster.ledgerndary.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.ledgerndary.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.ledgerndary_keycloak.token
  }
}

data "aws_eks_cluster_auth" "ledgerndary_keycloak" {
  name = aws_eks_cluster.ledgerndary.name
}

# Create the Keycloak namespace
resource "kubernetes_namespace" "keycloak" {
  metadata {
    name = "keycloak"
  }
}

# Deploy Keycloak using Helm
resource "helm_release" "keycloak" {
  name      = "keycloak"
  namespace = kubernetes_namespace.keycloak.metadata[0].name

  repository = "https://codecentric.github.io/helm-charts"
  chart      = "keycloak"
  version    = "18.4.0" # Adjust to the version you want to deploy

  create_namespace = false # Namespace is already created by the kubernetes_namespace resource

  # Load values from a file
  values = [
    file("${path.module}/keycloak-values.yaml")
  ]

  depends_on = [kubernetes_namespace.keycloak] # Ensure namespace is created first
  timeout    = 900
}
