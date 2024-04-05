output "dataform_repository_name" {
  value = local.repo_name
}

output "git_path" {
  value = local.git_path
}

output "dataform_config_all_vars_from_all_repos" {
  value = local.all_vars
}

output "datasets" {
  value = local.variables
}
