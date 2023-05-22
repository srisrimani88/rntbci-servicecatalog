resource "google_compute_instance" "default" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone
  allow_stopping_for_update = true

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = var.image
      #labels = {
      #my_label = "value"
      #}
    }
  }

  #// Local SSD disk
  #scratch_disk {
  #  interface = "SCSI"
  #}

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    #email  = "terraformsa@my-project-22-369304.iam.gserviceaccount.com"
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
resource "google_storage_bucket" "bucket" {
 count = 1
 name = "test-tm-mani-tf-bkt"
 location = "europe-west2"
 storage_class = "STANDARD"
}