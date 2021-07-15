resource "google_compute_address" "ingress" {
  name         = "ip-nginx-ingress"
  network_tier = "PREMIUM"

  depends_on = [
    google_project_service.project["compute.googleapis.com"]
  ]
}

resource "helm_release" "nginx_ingress" {
  name = "nginx-ingress-controller"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  set {
    name  = "service.loadBalancerIP"
    value = google_compute_address.ingress.address
  }

  depends_on = [
    module.gke_cluster
  ]
}

output "ingress_ip" {
  value = google_compute_address.ingress.address
}