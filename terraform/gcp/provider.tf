provider "google" {
  credentials = file("studied-sled-376713-206c54fc59f7.json")
  project     = "studied-sled-376713"
  region      = "us-central1"
  zone        = "us-central1-a"
}