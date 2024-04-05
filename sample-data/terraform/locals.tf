locals {

  git_repo_url_map = {
    for repo_key, repo_settings in var.dataform_repositories :
    repo_key => repo_settings.remote_repo_url
  }

  repo_prefix = {
    for repo_key, repo_url in local.git_repo_url_map :
    repo_key => replace(repo_url, "/.*/(.*)/.*\\.git/", "$1")
  }

  repo_name = {
    for repo_key, repo_url in local.git_repo_url_map :
    repo_key => replace(repo_url, "/.*/(.*)\\.git/", "$1")
  }

  git_path = {
    for repo_key in keys(local.git_repo_url_map) :
    repo_key => "${local.repo_prefix[repo_key]}/${local.repo_name[repo_key]}"
  }

  #Reads dataform.json files
  dataform_configs = [
    for repo_key, repo_data in var.dataform_repositories :
    jsondecode(data.github_repository_file.dataform_config[repo_key].content)
  ]
  all_vars = merge([
    for config in local.dataform_configs : config.vars
  ]...)

  /* Create BigLake Connection Name:
      "connection_name_YOUR_CONNECTION_NAME"
  */
  variables = ({
    for k, v in local.all_vars : k => {
      connection = v
    }...
    if k == "connection_name"
  })

  connections = {
    for dataset_name, attribute_list in local.variables : dataset_name => merge(attribute_list...)
  }
}