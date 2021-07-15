resource "google_compute_address" "ingress" {
  name         = "ip-nginx-ingress"
  network_tier = "PREMIUM"
}

resource "helm_release" "nginx_ingress" {
  name = "nginx-ingress-controller"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  set {
    name  = "service.loadBalancerIP"
    value = google_compute_address.ingress.address
  }
}

output "ingress_ip" {
  value = google_compute_address.ingress.address
}