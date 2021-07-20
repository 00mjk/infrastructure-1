resource "google_compute_global_address" "db_private_ip_address" {
  provider = google-beta

  name          = "tecnoly-database-0-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.private_network.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider = google-beta

  network                 = google_compute_network.private_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.db_private_ip_address.name]
}

resource "google_sql_database_instance" "mysql" {
  provider = google-beta
  name = "tecnoly-database-0"
  database_version = "MYSQL_8_0"
  settings{
    tier = "db-f1-micro"
     user_labels = {
      "environment" = "production"
    }
    maintenance_window {
      day  = "1"
      hour = "4"
    }
    backup_configuration {
      enabled = true
      start_time = "04:30"
    } 

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.private_network.id
    }
  }

  depends_on = [google_service_networking_connection.private_vpc_connection]

}

output "database_host" {
  value = google_compute_global_address.db_private_ip_address.address
}

output "database_instance_name" {
  value = google_sql_database_instance.mysql.name
}
