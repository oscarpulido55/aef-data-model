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

# Create storage bucket.
resource "google_storage_bucket" "sample_landing_data_bucket" {
  name                     = "${var.landing_data_project_id}-sample-raw-data-bucket"
  location                 = var.region
  project                  = var.landing_data_project_id
  public_access_prevention = "enforced"
  force_destroy            = true
}

# Copy files to gcs, create partitions
resource "google_storage_bucket_object" "location" {
  name       = "locations/location.csv"
  source     = "../sample-data/gcs_files/location.csv"
  bucket     = google_storage_bucket.sample_landing_data_bucket.name
  depends_on = [google_storage_bucket.sample_landing_data_bucket]
}

resource "google_storage_bucket_object" "product" {
  name       = "products/product.csv"
  source     = "../sample-data/gcs_files/product.csv"
  bucket     = google_storage_bucket.sample_landing_data_bucket.name
  depends_on = [google_storage_bucket.sample_landing_data_bucket]
}

resource "google_storage_bucket_object" "sales-dt1" {
  name       = "sales/2024-03-11/sales_dt1.csv"
  source     = "../sample-data/gcs_files/sales_dt1.csv"
  bucket     = google_storage_bucket.sample_landing_data_bucket.name
  depends_on = [google_storage_bucket.sample_landing_data_bucket]
}

resource "google_storage_bucket_object" "sales-dt2" {
  name       = "/sales/2024-03-12/sales_dt2.csv"
  source     = "../sample-data/gcs_files/sales_dt2.csv"
  bucket     = google_storage_bucket.sample_landing_data_bucket.name
  depends_on = [google_storage_bucket.sample_landing_data_bucket]
}