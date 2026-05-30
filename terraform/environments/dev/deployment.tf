resource "kubernetes_deployment" "app" {

  metadata {
    name = "devops-app"
    labels = {
      app = "devops-app"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "devops-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "devops-app"
        }
      }

      spec {
        container {
          name  = "devops-app"
          image = var.image

          port {
            container_port = 80
          }
        }
      }
    }
  }
}