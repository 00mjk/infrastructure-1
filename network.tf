resource "google_compute_network" "private_network" {
  provider = google-beta
  name = "tecnoly-private"

  depends_on = [
    google_project_service.project["compute.googleapis.com"]
  ]
}