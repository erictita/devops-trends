resource "kubernetes_service" "app" {

  metadata {
    name = "devops-service"
  }

  spec {
    selector = {
      app = "devops-app"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}