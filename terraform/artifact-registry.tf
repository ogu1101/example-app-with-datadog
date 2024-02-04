resource "google_artifact_registry_repository" "my-repo" {
  location      = var.region
  repository_id = "${var.env}-repository"
  description   = "${var.env} docker repository"
  format        = "DOCKER"
}
