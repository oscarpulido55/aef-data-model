## Demo Appendix
Use this in case you want to create some sample data sources (GCS bucket with some files, and a Cloud SQL Postgres DB with 1 populated table), this will:
  - Create a BigLake connection for GCS files.
  - Create data landing GCS buckets. And uploads sample data.
  - Create a dummy PostgreSQL database to simulate an on-premises data source that can't be accessed using BigQuery Omni or BigLake. And inserts sample data.

### Usage
**Important:** Using this repository involves creating tables and managing data. We've included simple data and tables for demonstration.

#### Steps
1. **Terraform:** Define your terraform variables. We recommend creating a `.tfvars` file.
```hcl
project             = "my-project"
region              = "us-central1"
sample_data_bucket  = "my-sample-data-bucket"
sample_default_date = "2024-02-26"

git_token             = "my-git-token-value"
dataform_repositories = {
  sample-repo-1 = {
    remote_repo_url      = "https://github.com/my-dataform-repo.git"
    secret_name          = "my-github-token-secret-1"
    service_account_name = "aef-dataform-repo1-sa"
  }
}
sample_files = {
  "location" = {
    name   = "locations/location.csv"
    source = "../gcs-files/location.csv"
  },
  "product" = {
    name   = "products/product.csv"
    source = "../gcs-files/product.csv"
  },
  "sales-dt1" = {
    name   = "sales/2024-03-11/sales_dt1.csv"
    source = "../gcs-files/sales_dt1.csv"
  },
  "sales-dt2" = {
    name   = "/sales/2024-03-12/sales_dt2.csv"
    source = "../gcs-files/sales_dt2.csv"
  }
}
```
1. Run the Terraformn Plan / Apply
```commandline
terraform plan -var-file="demo.tfvars"
```

1. Cleaning
```commandline
terraform destroy -var-file="demo.tfvars"
```
