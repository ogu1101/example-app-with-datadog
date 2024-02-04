output "region" {
  value       = var.region
  description = "GCloud Region"
}

output "project_id" {
  value       = var.project_id
  description = "GCloud Project ID"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}

output "gke_global_ip_address_name" {
  value       = google_compute_global_address.gke_global_ip_address.name
  description = "GKE Global IP Address Name"
}

output "cloud_sql_instance_name" {
  value       = google_sql_database_instance.main.name
  description = "Cloud SQL Instance Name"
}

output "service_account_id" {
  value       = google_service_account.service_account.account_id
  description = "Service Account ID"
}

output "artifact_registry_repository_name" {
  value       = google_artifact_registry_repository.my-repo.name
  description = "Artifact Registry Repository Name"
}
