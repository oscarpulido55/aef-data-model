terraform {
  backend "gcs" {
    bucket = "aef-aef-test-may-8-1-tfe"
    prefix = "sample-data/environments/dev"
  }
}