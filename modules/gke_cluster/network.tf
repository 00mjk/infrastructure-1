resource "google_compute_subnetwork" "k8s_subnet" {
  name                     = "${var.gke_cluster_name}-subnet"
  ip_cidr_range            = var.primary_ip_cidr
  network                  = var.vpc_id
  private_ip_google_access = "true"
  region                   = var.region
  #  secondary_ip_range = [
  #    {
  #      range_name    = var.secondary_pods_range_name
  #      ip_cidr_range = var.secondary_pods_cidr
  #    },
  #    {
  #      range_name    = var.secondary_services_range_name
  #      ip_cidr_range = var.secondary_services_cidr
  #    }
  #  ]
}