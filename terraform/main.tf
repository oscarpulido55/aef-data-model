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
  connection_id = "${var.project}-sample-connection"
  project       = var.project
  location      = var.region
  cloud_resource {}
}

# Grants permissions to the service account of the connection created in the last step.
resource "google_project_iam_member" "connectionPermissionGrant" {
  project = var.project
  role    = "roles/storage.objectViewer"
  member  = format("serviceAccount:%s", google_bigquery_connection.connection.cloud_resource[0].service_account_id)
}

# Create datasets define via terraform variables if any
resource "google_bigquery_dataset" "datasets" {
  for_each   = var.datasets
  dataset_id = each.value.dataset_id
  project    = each.value.project_id
  location   = each.value.location
}

# Create dataform parameters file
resource "local_file" "dataform_config" {
  content  = <<EOF
  {
    "defaultSchema": "dataform",
    "assertionSchema": "dataform_assertions",
    "defaultLocation": "${var.region}",
    "warehouse": "bigquery",
    "vars": {
      "connection_name": "${google_bigquery_connection.connection.connection_id}",
      ${local.dataset_vars},
      ${local.demo_dataform_vars_trimmed}
    }
  }
  EOF
  filename = "../dataform/dataform.json"
}