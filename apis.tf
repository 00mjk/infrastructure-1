locals {
  services = [
    "sqladmin.googleapis.com",
    "compute.googleapis.com",
    "servicenetworking.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "container.googleapis.com",
  ]
}

resource "google_project_service" "project" {
  for_each = toset(local.services)

  service = each.key
  disable_on_destroy = true
  disable_dependent_services=true
}
