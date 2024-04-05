project               = "pso-amex-data-platform"
region                = "us-central1"
domain                = "google"
git_token             = "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"
dataform_repositories = {
  sample-repo-1 = {
    remote_repo_url      = "https://github.com/oscarpulido55/aef-sample-dataform-repo.git"
    secret_name          = "my-github-token-secret-1"
    service_account_name = "aef-dataform-repo1-sa"
  },
  sample-repo-2 = {
    remote_repo_url      = "https://github.com/oscarpulido55/aef-sample-dataform-repo-2.git"
    secret_name          = "my-github-token-secret-2"
    service_account_name = "aef-dataform-repo2-sa"
  }
}