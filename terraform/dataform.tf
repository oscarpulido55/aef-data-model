#Search for and read dataform.json files in the input dataform repositories
data "github_repository_file" "dataform_config" {
  for_each   = var.dataform_repositories
  repository = local.git_path[each.key]
  branch     = each.value.branch
  file       = "dataform.json"
}

#In order to enable dataform to communicate with a 3P GIT provider, an access token must be generated and stored as a secret on GCP
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
        data    = var.dataform_repositories_git_token
      }
    }
  }
  iam = {
    "${each.value.secret_name}" = {
      "roles/secretmanager.secretAccessor" = [
        "serviceAccount:service-${data.google_project.project.number}@gcp-sa-dataform.iam.gserviceaccount.com"
        #module.dataform-service-accounts[each.key].iam_email
      ]
    }
  }
}

resource "google_project_iam_member" "dataform_bigquery_owner" {
  project = var.project
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-dataform.iam.gserviceaccount.com"
}

#creates a dataform repository with a remote repository attached to it.
module "dataform_with_external_repos" {
  for_each                   = var.create_dataform_repositories ? var.dataform_repositories : {}
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
}


/* Create datasets defined via dataform.json variables if any, it should include 3 variables for each dataset with next format:
    "dataset_id_<DATASET_IDENTIFIER>":"<YOUR_DATASET_NAME>",
    "dataset_projectid_<DATASET_IDENTIFIER>":"<YOUR_DATASET_PROJECT>",
    "dataset_location_<DATASET_IDENTIFIER>":"<YOUR_DATASET_LOCATION>",
*/
resource "google_bigquery_dataset" "datasets" {
  for_each    = var.create_dataform_datasets ? local.datasets : {}
  dataset_id  = each.value.id
  project     = each.value.projectid
  location    = each.value.location
  description = each.value.description
}

#Run the dataform scripts found in the repositories
resource "null_resource" "run_dataform_deployer" {
  for_each = var.compile_dataform_repositories ? var.dataform_repositories : {}
  provisioner "local-exec" {
    command = <<EOF
      python3 -m venv aef_dataform_execuor
      source aef_dataform_execuor/bin/activate
      pip install google-api-core
      pip install google-cloud-dataform
      python3 ../cicd-deployers/dataform_runner.py --project_id ${var.project} --location ${var.region} --repository ${each.key} --tags ddl --execute ${var.execute_dataform_repositories} --branch ${each.value.branch}
    EOF
  }
  depends_on = [module.dataform_with_external_repos]
  triggers   = {
    always_run = timestamp()
  }
}