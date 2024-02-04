resource "google_service_account" "service_account" {
  account_id   = "${var.env}-service-account-id"
  display_name = "${var.env}-Service Account"
}

resource "google_project_iam_binding" "logging_logWriter" {
  project = var.project_id
  role    = "roles/logging.logWriter"

  members = [
    google_service_account.service_account.member,
  ]
}

resource "google_project_iam_binding" "monitoring_admin" {
  project = var.project_id
  role    = "roles/monitoring.admin"

  members = [
    google_service_account.service_account.member,
  ]
}

resource "google_project_iam_binding" "artifactregistry_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"

  members = [
    google_service_account.service_account.member,
  ]
}

resource "google_project_iam_binding" "cloudsql_editor" {
  project = var.project_id
  role    = "roles/cloudsql.editor"

  members = [
    google_service_account.service_account.member,
  ]
}

resource "google_project_iam_binding" "container_admin" {
  project = var.project_id
  role    = "roles/container.admin"

  members = [
    google_service_account.service_account.member,
  ]
}

resource "google_project_iam_binding" "iam_serviceAccountAdmin" {
  project = var.project_id
  role    = "roles/iam.serviceAccountAdmin"

  members = [
    google_service_account.service_account.member,
  ]
}

resource "google_service_account_iam_binding" "iam_workloadIdentityUser" {
  service_account_id = google_service_account.service_account.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[default/ksa-cloud-sql]",
  ]
}
