resource "google_sql_database_instance" "main" {
  name             = "${var.env}-cloud-sql"
  database_version = "POSTGRES_15"
  region           = var.region
  root_password    = "password"

  deletion_protection = false

  settings {
    tier = "db-custom-2-7680"
    availability_type = "REGIONAL"
    
    ip_configuration {
      authorized_networks {
        name  = google_container_cluster.primary.name
        value = google_container_cluster.primary.endpoint
      }
    }

    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
      start_time                     = "20:55"
    }
  }
}
