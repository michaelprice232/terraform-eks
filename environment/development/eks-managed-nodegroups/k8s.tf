# Tiller service account
resource "kubernetes_service_account" "tiller" {
  metadata {
    name      = "tiller-sa"
    namespace = "kube-system"
  }
  secret {
    name = kubernetes_secret.tiller.metadata.0.name
  }
}

resource "kubernetes_secret" "tiller" {
  metadata {
    name = "tiller-secret"
  }
}

resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "tiller-cluster-role-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.tiller.metadata[0].name
    namespace = kubernetes_service_account.tiller.metadata[0].namespace
  }
}