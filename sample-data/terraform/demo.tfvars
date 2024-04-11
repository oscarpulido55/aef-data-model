project             = "pso-amex-data-platform"
region              = "us-central1"
sample_default_date = "2024-02-26"

git_token             = "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"
dataform_repositories = {
  sample-repo-1 = {
    remote_repo_url      = "https://github.com/oscarpulido55/aef-sample-dataform-repo.git"
    secret_name          = "my-github-token-secret-1"
  }
}

sample_data_bucket  = "pso-amex-data-platform-my-sample-data-bucket"
sample_data_files = {
  "location" = {
    name   = "locations/location.csv"
    source = "../gcs-files/location.csv"
  },
  "product" = {
    name   = "products/product.csv"
    source = "../gcs-files/product.csv"
  },
  "sales-dt1" = {
    name   = "sales/dt=2024-03-11/sales_dt1.csv"
    source = "../gcs-files/sales_dt1.csv"
  },
  "sales-dt2" = {
    name   = "sales/dt=2024-03-12/sales_dt2.csv"
    source = "../gcs-files/sales_dt2.csv"
  }
}

sample_ddl_bucket  = "pso-amex-data-platform-my-sample-ddl-bucket"
sample_ddl_files = {
  "location" = {
    name   = "raw_sales.sql"
    source = "../gcs-files/raw_sales.sql"
  }
}