resource "google_compute_network" "vpc" {
  name                    = "${var.env}-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.env}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}

resource "google_compute_firewall" "inbound" {
  name    = "${var.env}-inbound-firewall"
  network = google_compute_network.vpc.name

  source_ranges = ["${var.your_global_ip_address}"]
  target_tags   = ["${var.env}-gke"]

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
}

resource "google_compute_global_address" "gke_global_ip_address" {
  name = "${var.env}-ip-address"
}
