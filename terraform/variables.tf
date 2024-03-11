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

variable "landing_data_project_id" {
  type        = string
  nullable    = false
}

variable "curated_data_project_id" {
  type        = string
  nullable    = false
}

variable "exposure_data_project_id" {
  type        = string
  nullable    = false
}

variable "region" {
  type        = string
  nullable    = false
}

variable "landing_bq_dataset_name" {
  type        = string
  nullable    = false
  default = "landing_sample_dataset"
}

variable "curated_bq_dataset_name" {
  type        = string
  nullable    = false
  default = "curated_sample_dataset"
}

variable "exposure_bq_dataset_name" {
  type        = string
  nullable    = false
  default = "exposure_sample_dataset"
}

variable "sample_start_date" {
  type        = string
  nullable    = false
  default = "2024-02-26"
}

variable "sample_end_date" {
  type        = string
  nullable    = false
  default = "2024-02-26"
}