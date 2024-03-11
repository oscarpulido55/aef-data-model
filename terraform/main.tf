/**
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# Creates a cloud resource connection.
resource "google_bigquery_connection" "connection" {
  connection_id = "${var.landing_data_project_id}-raw-sample-connection"
  project       = var.landing_data_project_id
  location      = var.region
  cloud_resource {}
}

## Grants permissions to the service account of the connection created in the last step.
resource "google_project_iam_member" "connectionPermissionGrant" {
  project = var.landing_data_project_id
  role    = "roles/storage.objectViewer"
  member  = format("serviceAccount:%s", google_bigquery_connection.connection.cloud_resource[0].service_account_id)
}

#Create landing bigquery dataset
resource "google_bigquery_dataset" "sample_landing_dataset" {
   project = var.landing_data_project_id
   dataset_id = var.landing_bq_dataset_name
   location   = var.region
}

#Create curated bigquery dataset
resource "google_bigquery_dataset" "sample_curated_dataset" {
   project = var.curated_data_project_id
   dataset_id = var.curated_bq_dataset_name
   location   = var.region
}

#Create exposure bigquery dataset
resource "google_bigquery_dataset" "sample_exposure_dataset" {
   project = var.curated_data_project_id
   dataset_id = var.exposure_bq_dataset_name
   location   = var.region
}

# Create dataform parameters file
resource "local_file" "dataform_config" {
  content = <<EOF
  {
    "defaultSchema": "dataform",
    "assertionSchema": "dataform_assertions",
    "warehouse": "bigquery",
    "defaultDatabase": "${google_bigquery_dataset.sample_landing_dataset.dataset_id}",
    "defaultLocation": "${var.region}",
    "vars": {
      "landing_project_id": "${var.landing_data_project_id}",
      "curated_project_id": "${var.landing_data_project_id}",
      "exposure_project_id": "${var.landing_data_project_id}",
      "landing_dataset_id": "${google_bigquery_dataset.sample_landing_dataset.dataset_id}",
      "curated_dataset_id": "${google_bigquery_dataset.sample_curated_dataset.dataset_id}",
      "exposure_dataset_id": "${google_bigquery_dataset.sample_exposure_dataset.dataset_id}",
      "landing_storage_bucket": "${google_storage_bucket.sample_landing_data_bucket.name}",
      "connection_name": "${google_bigquery_connection.connection.connection_id}",
      "start_date": "${var.sample_start_date}",
      "end_date": "${var.sample_end_date}"
    }
  }
  EOF
  filename = "../dataform/dataform.json"
}