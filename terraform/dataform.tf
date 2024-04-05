#In order to enable dataform to communicate with a 3P GIT provider,
#an access token must be generated and stored as a secret on GCP
module "secrets" {
  for_each   = var.dataform_repositories
  source     = "github.com/GoogleCloudPlatform/cloud-foundation-fabric/modules/secret-manager"
  project_id = var.project
  secrets    = {
    "${each.value.secret_name}" = {
    }
  }
  versions = {
    "${each.value.secret_name}" = {
      "${each.value.secret_version}" = {
        enabled = true,
        data    = var.git_token
      }
    }
  }
  iam = {
    "${each.value.secret_name}" = {
      "roles/secretmanager.secretAccessor" = [
        module.dataform-service-accounts[each.key].iam_email
      ]
    }
  }
}

#creates a dataform repository with a remote repository attached to it.
module "dataform_with_external_repos" {
  for_each                   = var.dataform_repositories
  source                     = "github.com/GoogleCloudPlatform/cloud-foundation-fabric/modules/dataform-repository"
  project_id                 = var.project
  name                       = each.key
  region                     = var.region
  remote_repository_settings = {
    url            = each.value.remote_repo_url
    branch         = each.value.branch
    secret_name    = each.value.secret_name
    secret_version = module.secrets[each.key].version_ids["${var.dataform_repositories[each.key].secret_name}:${var.dataform_repositories[each.key].secret_version}"]
  }
  service_account = module.dataform-service-accounts[each.key].iam_email
}

module "dataform-service-accounts" {
  for_each          = var.dataform_repositories
  source            = "github.com/GoogleCloudPlatform/cloud-foundation-fabric/modules/iam-service-account"
  project_id        = var.project
  name              = each.value.service_account_name
  iam_project_roles = {
    "${var.project}" = [
      "roles/dataform.editor"
    ]
  }
}