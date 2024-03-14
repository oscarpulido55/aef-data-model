locals {
  datasets = jsonencode({
    for ds_key, ds in var.datasets : format("%s_dataset_id", ds_key) =>  ds.dataset_id
  })
  dataset_tm = substr(local.datasets, 1, length(local.datasets) - 2)

  projects = jsonencode({
    for ds_key, ds in var.datasets : format("%s_project_id", ds_key) =>  ds.project_id
  })
  projects_tm = substr(local.projects, 1, length(local.projects) - 2)

  locations = jsonencode({
    for ds_key, ds in var.datasets : format("%s_location", ds_key) =>  ds.location
  })
  locations_tm = substr(local.locations, 1, length(local.locations) - 2)

  dataset_vars = format("%s,%s,%s", local.dataset_tm, local.projects_tm, local.locations_tm)

  demo_dataform_vars= jsonencode({
    sample_data_bucket: length(google_storage_bucket.sample_data_bucket) > 0 ? google_storage_bucket.sample_data_bucket[0].name : "",
    start_date: var.sample_default_date ,
    end_date: var.sample_default_date
  })
  demo_dataform_vars_trimmed = substr(local.demo_dataform_vars, 1, length(local.demo_dataform_vars) - 2)
}