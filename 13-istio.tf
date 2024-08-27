provider "kubernetes" {
  alias                  = "istio"
  host                   = aws_eks_cluster.ledgerndary.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.ledgerndary.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.ledgerndary_istio.token
}

provider "helm" {
  alias = "istio"
  kubernetes {
    host                   = aws_eks_cluster.ledgerndary.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.ledgerndary.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.ledgerndary_istio.token
  }
}

data "aws_eks_cluster_auth" "ledgerndary_istio" {
  name = aws_eks_cluster.ledgerndary.name
}

# Create the istio-system namespace
resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = "istio-system"
  }
}

resource "helm_release" "istio" {
  name      = "istio-base"
  namespace = kubernetes_namespace.istio_system.metadata[0].name

  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  version    = "1.18.2" # Adjust to the version you want to deploy
  #version          = "1.23.0"

  create_namespace = false # Namespace is already created by the kubernetes_namespace resource

  depends_on = [kubernetes_namespace.istio_system]
}

resource "helm_release" "istio_discovery" {
  name      = "istiod"
  namespace = kubernetes_namespace.istio_system.metadata[0].name

  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  version    = "1.18.2" # Adjust to the version you want to deploy
  #version          = "1.23.0"

  create_namespace = false

  depends_on = [kubernetes_namespace.istio_system, helm_release.istio]
}

resource "helm_release" "istio_ingress" {
  name      = "istio-ingress"
  namespace = kubernetes_namespace.istio_system.metadata[0].name

  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  version    = "1.18.2" # Adjust to the version you want to deploy
  #version          = "1.23.0"
  create_namespace = false

  values = [
    file("${path.module}/istio-ingress-values.yaml")
  ]

  depends_on = [kubernetes_namespace.istio_system, helm_release.istio, helm_release.istio_discovery]
  timeout    = 900
}
