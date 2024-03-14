project             = "pso-amex-data-platform"
region              = "us-central1"
create_demo_data    = false

datasets = {
  "landing_dataset" = {
    dataset_id = "landing_sample_dataset"
    project_id = "pso-amex-data-platform"
    location   = "us-central1"
  },
  "curated_dataset" = {
    dataset_id = "curated_sample_dataset"
    project_id = "pso-amex-data-platform"
    location   = "us-central1"
  },
  "exposure_dataset" = {
    dataset_id = "exposure_sample_dataset"
    project_id = "pso-amex-data-platform"
    location   = "us-central1"
  }
}