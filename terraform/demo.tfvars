project             = "pso-amex-data-platform"
region              = "us-central1"
sample_data_bucket  = "my-sample-data-bucket"
sample_default_date = "2024-02-26"
create_demo_data    = true

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

sample_files = {
  "location" = {
    name   = "locations/location.csv"
    source = "../sample-data/gcs_files/location.csv"
  },
  "product" = {
    name   = "products/product.csv"
    source = "../sample-data/gcs_files/product.csv"
  },
  "sales-dt1" = {
    name   = "sales/2024-03-11/sales_dt1.csv"
    source = "../sample-data/gcs_files/sales_dt1.csv"
  },
  "sales-dt2" = {
    name   = "/sales/2024-03-12/sales_dt2.csv"
    source = "../sample-data/gcs_files/sales_dt2.csv"
  }
}