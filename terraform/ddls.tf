#Run the BigQuery ddls found in the ddl buckets
resource "null_resource" "run_ddls" {
  for_each = var.run_ddls_in_buckets ? var.ddl_buckets : {}
  provisioner "local-exec" {
    command = <<EOF
      python3 -m venv aef_bigquery_ddl_runner
      source aef_bigquery_ddl_runner/bin/activate
      pip install google-api-core
      pip install google-cloud-bigquery
      pip install google-cloud-storage
      python3 ../cicd-deployers/bigquery_ddl_runner.py --project_id ${each.value.bucket_project} --location ${each.value.bucket_region} --bucket ${each.value.bucket_name} --ddl_project_id ${each.value.ddl_project_id} --ddl_dataset_id ${each.value.ddl_dataset_id} --ddl_data_bucket_name ${each.value.ddl_data_bucket_name} --ddl_connection_name ${each.value.ddl_connection_name}
    EOF
  }
  triggers   = {
    always_run = timestamp()
  }
}