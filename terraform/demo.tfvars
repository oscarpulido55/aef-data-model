project             = "pso-amex-data-platform"
region              = "us-central1"
sample_data_bucket  = "my-sample-data-bucket"
sample_default_date = "2024-02-26"
dataform_params  = "../data-model/dataform_repositories/sample_dataform_repository/dataform.json"

create_demo_data    = true

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