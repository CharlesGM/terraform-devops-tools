provider "kubernetes" {
  host                   = aws_eks_cluster.ledgerndary.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.ledgerndary.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.ledgerndary_prometheus.token
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.ledgerndary.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.ledgerndary.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.ledgerndary_prometheus.token
  }
}

data "aws_eks_cluster_auth" "ledgerndary_prometheus" {
  name = aws_eks_cluster.ledgerndary.name
}

# Create the monitoring namespace
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "kube_prometheus_stack" {
  name      = "kube-prometheus-stack"
  namespace = "monitoring"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "51.2.0" # Adjust to the version you want to deploy

  create_namespace = true

  # Load values from a file
  values = [
    file("${path.module}/prometheus-values.yaml")
  ]

  depends_on = [kubernetes_namespace.monitoring] # Ensure namespace is created first
}

