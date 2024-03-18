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

/* Create datasets defined via dataform.json variables if any, it should include 3 variables for each dataset with next format:
    "dataset_id_<DATASET_IDENTIFIER>":"<YOUR_DATASET_NAME>",
    "dataset_projectid_<DATASET_IDENTIFIER>":"<YOUR_DATASET_PROJECT>",
    "dataset_location_<DATASET_IDENTIFIER>":"<YOUR_DATASET_LOCATION>",
*/
resource "google_bigquery_dataset" "datasets" {
  for_each   = local.datasets
  dataset_id = each.value.id
  project    = each.value.projectid
  location   = each.value.location
  description = each.value.description
}

resource "null_resource" "run_metadata_deployer" {
  provisioner "local-exec" {
    command = "python ../data-model/metadata_deployer.py --project_id ${var.project} --location ${var.region}"
  }
}