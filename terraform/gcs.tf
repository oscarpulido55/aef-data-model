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