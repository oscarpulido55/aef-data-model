terraform {
  backend "gcs" {
    bucket = "aef-aef-test-may-8-1-tfe"
    prefix = "aef-data-model/environments/dev"
  }
}