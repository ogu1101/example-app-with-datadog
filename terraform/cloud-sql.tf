resource "google_sql_database_instance" "main" {
  name             = "${var.env}-cloud-sql"
  database_version = "POSTGRES_15"
  region           = var.region
  root_password    = "password"

  deletion_protection = false

  settings {
    tier = "db-custom-2-7680"
    ip_configuration {
      authorized_networks {
        name  = google_container_cluster.primary.name
        value = google_container_cluster.primary.endpoint
      }
    }
  }
}
