# Simple Output: List of Created Dataset IDs
output "dataset_ids" {
  value = [for dataset in google_bigquery_dataset.datasets : dataset.dataset_id]
}

# Detailed Output: Map of Datasets with Properties
output "datasets_info" {
  value = {
    for dataset in google_bigquery_dataset.datasets : dataset.dataset_id => {
      dataset_id = dataset.dataset_id
      project_id = dataset.project
      location   = dataset.location
    }
  }
}