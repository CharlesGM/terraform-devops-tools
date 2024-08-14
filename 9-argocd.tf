# provider "kubernetes" {
#   # alias       = "argocd"
#   config_path = "~/.kube/config" # Adjust as needed for your kubeconfig path
# }

# provider "helm" {
#   # alias = "argocd"
#   kubernetes {
#     config_path = "~/.kube/config" # Adjust as needed for your kubeconfig path
#   }
# }


provider "kubernetes" {
  alias                  = "argocd"
  host                   = aws_eks_cluster.ledgerndary.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.ledgerndary.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.ledgerndary_argocd.token
}

provider "helm" {
  alias = "argocd"
  kubernetes {
    host                   = aws_eks_cluster.ledgerndary.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.ledgerndary.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.ledgerndary_argocd.token
  }
}

data "aws_eks_cluster_auth" "ledgerndary_argocd" {
  name = aws_eks_cluster.ledgerndary.name
}

# Create the argocd namespace
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name      = "argocd"
  namespace = kubernetes_namespace.argocd.metadata[0].name # Reference the created namespace

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.29.0" # Adjust to the version you want to deploy

  create_namespace = false # Namespace is already created by the kubernetes_namespace resource

  # Load values from a file
  values = [
    file("${path.module}/argocd-values.yaml")
  ]

  depends_on = [kubernetes_namespace.argocd] # Ensure namespace is created first
}
