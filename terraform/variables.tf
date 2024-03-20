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

variable "project" {
  description = "Project where the core BigLake bigquery_connection and other resources will be created."
  type        = string
  nullable    = false
}

variable "region" {
  description = "Region where the core BigLake bigquery_connection and other resources will be created."
  type        = string
  nullable    = false
}

variable "dataform_params" {
  description = "dataform.json parameters file that will define the datasets that need to be created via terraform."
  type = string
  nullable    = false
}

variable "remote_repo_url" {
  description = "Attached remote repository for the dataform repository."
  type = string
  nullable    = true
  default = ""
}

#------------------------------------------------------------------------------------
#From here variables are optional and util for demo purposes only
#------------------------------------------------------------------------------------

variable "create_demo_data" {
  description = "Variable that will define if demo BD will be created and if demo files will be uploaded. "
  type        = string
  default     = false
}

variable "sample_data_bucket" {
  nullable    = true
  default     = null
  description = "Bucket where sample data will be stored."
  type        = string
}

variable "sample_files" {
  nullable = true
  default  = null
  type     = map(object({
    name   = string
    source = string
  }))
  description = "A map where values are objects containing 'source' (path to the file) and optional 'content'."
}

variable "sample_default_date" {
  nullable = true
  default  = null
  type     = string
}