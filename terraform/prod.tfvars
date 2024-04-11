project = "pso-amex-data-platform"
region  = "us-central1"
domain  = "google"

include_metadata_in_tfe_deployment = true

create_dataform_repositories    = true
compile_dataform_repositories   = true
execute_dataform_repositories   = true
create_dataform_datasets        = true
dataform_repositories_git_token = "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"
dataform_repositories           = {
  sample-repo-1 = {
    remote_repo_url = "https://github.com/oscarpulido55/aef-sample-dataform-repo.git"
    secret_name     = "my-github-token-secret-1"
  },
  sample-repo-2 = {
    remote_repo_url = "https://github.com/oscarpulido55/aef-sample-dataform-repo-2.git"
    secret_name     = "my-github-token-secret-2"
  }
}

create_data_buckets = false
data_buckets        = {
  data-bucket-1 = {
    name          = "pso-amex-data-platform-my-sample-data-bucket"
    region        = "us-central1"
    project       = "pso-amex-data-platform"
    dataplex_lake = "sales-lake"
    dataplex_zone = "landing-zone"
  }
}

create_ddl_buckets  = false
run_ddls_in_buckets = true
ddl_buckets         = {
  ddl-bucket-1 = {
    bucket_name          = "pso-amex-data-platform-my-sample-ddl-bucket"
    bucket_region        = "us-central1"
    bucket_project       = "pso-amex-data-platform"
    ddl_flavor           = "bigquery"
    ddl_project_id       = "pso-amex-data-platform"
    ddl_dataset_id       = "landing_sample_dataset"
    ddl_data_bucket_name = "pso-amex-data-platform-my-sample-data-bucket"
    ddl_connection_name  = "projects/pso-amex-data-platform/locations/us-central1/connections/sample-connection"
  }
}