#In order to enable dataform to communicate with a 3P GIT provider,
#an access token must be generated and stored as a secret on GCP
module "secret" {
  count      = var.remote_repo_url != "" ? 1 : 0
  source     = "github.com/GoogleCloudPlatform/cloud-foundation-fabric/modules/secret-manager"
  project_id = var.project
  secrets    = {
    my-secret = {
    }
  }
  versions = {
    my-secret = {
      v1 = { enabled = true, data = "MYTOKEN" }
    }
  }
}

#creates a dataform repository with a remote repository attached to it.
module "dataform_with_external_repo" {
  count                      = var.remote_repo_url != "" ? 1 : 0
  source                     = "github.com/GoogleCloudPlatform/cloud-foundation-fabric/modules/dataform-repository"
  project_id                 = var.project
  name                       = local.repository_name
  region                     = var.region
  remote_repository_settings = {
    url         = var.remote_repo_url
    secret_name = "my-secret"
    token       = module.secret[0].version_ids["my-secret:v1"]
  }
}

##creates a dataform repository without remote repo, if repo url variable is empty.
module "dataform" {
  count      = var.remote_repo_url == "" ? 1 : 0
  source     = "github.com/GoogleCloudPlatform/cloud-foundation-fabric/modules/dataform-repository"
  project_id = var.project
  name       = local.repository_name
  region     = var.region
}
