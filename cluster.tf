module "gke_cluster" {
  source = "./modules/gke_cluster"

  vpc_id = google_compute_network.private_network.id
  region = var.region
  zone   = var.zone

  primary_ip_cidr          = "192.168.0.0/26" # max node IPs = 64 (max nodes = 60; 4 IPs reservered in every VPC)
  max_pods_per_node        = "32"             # max pods per node <= half of max node IPs
  cluster_ipv4_cidr_block  = "10.0.0.0/18"    # max pod IPs = 15360 (60 * 256), CIDR must be able to cover for all the potential IPs
  services_ipv4_cidr_block = "10.1.0.0/20"

  channel      = "REGULAR"
  auto_upgrade = "true"

  gke_cluster_name               = "tecnoly-us-central1-0"
  master_authorized_network_cidr = "0.0.0.0/0"
  enable_private_endpoint        = "false"
  enable_private_nodes           = "false"

  machine_type = "e2-small"
  disk_size_gb = "40"
  max_nodes    = "1"

  depends_on = [
    google_project_service.project["container.googleapis.com"]
  ]
}
  
output "cluster_ca_certificate" {
  sensitive = true
  value = module.gke_cluster.cluster_ca_certificate
}

output "endpoint" {
  value = module.gke_cluster.endpoint
}
