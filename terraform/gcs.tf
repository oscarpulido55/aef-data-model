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

# Create cortex temporal storage bucket, to store tmp files generated during deployment.
resource "google_storage_bucket" "tmp_cortex_bucket" {
  name                     = "${var.project}-cortex-tmp-bucket"
  location                 = var.region
  project                  = var.project
  public_access_prevention = "enforced"
  force_destroy            = true
}

#------------------------------------------------------------------------------------
# Resources FROM here will be created optionally if demo mode is enabled
#------------------------------------------------------------------------------------

# Create sample storage bucket.
resource "google_storage_bucket" "sample_data_bucket" {
  count                    = var.create_demo_data ? 1 : 0
  name                     = "${var.project}-${var.sample_data_bucket}"
  location                 = var.region
  project                  = var.project
  public_access_prevention = "enforced"
  force_destroy            = true
}

# Copy files to gcs, create partitions
resource "google_storage_bucket_object" "objects" {
  for_each   = var.create_demo_data == true ? {} : (var.sample_files != null ? var.sample_files : {})
  name       = each.value.name
  source     = each.value.source
  bucket     = google_storage_bucket.sample_data_bucket[0].name
  depends_on = [google_storage_bucket.sample_data_bucket]
}

# Creates a cloud resource connection.
resource "google_bigquery_connection" "connection" {
  count         = var.create_demo_data ? 1 : 0
  connection_id = local.connection_name[0]
  project       = var.project
  location      = var.region
  cloud_resource {}
}

# Grants permissions to the service account of the connection created in the last step.
resource "google_project_iam_member" "connectionPermissionGrant" {
  count   = var.create_demo_data ? 1 : 0
  project = var.project
  role    = "roles/storage.objectViewer"
  member  = format("serviceAccount:%s", google_bigquery_connection.connection[0].cloud_resource[0].service_account_id)
}