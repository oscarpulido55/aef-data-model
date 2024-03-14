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

module "fake_on_prem_instance" {
  count          = var.create_demo_data ? 1 : 0
  source         = "github.com/GoogleCloudPlatform/cloud-foundation-fabric/modules/cloudsql-instance"
  project_id     = var.project
  network_config = {
    connectivity = {
      public_ipv4 = true
      psa_config  = {
        private_network = module.vpc[0].self_link
      }
    }
  }
  name                          = "fake-on-prem-instance"
  region                        = var.region
  database_version              = "POSTGRES_13"
  tier                          = "db-g1-small"
  gcp_deletion_protection       = "false"
  terraform_deletion_protection = "false"
  depends_on                    = [module.vpc]
}

module "vpc" {
  count      = var.create_demo_data ? 1 : 0
  source     = "github.com/GoogleCloudPlatform/cloud-foundation-fabric/modules/net-vpc"
  project_id = var.project
  name       = "fake-on-prem-network-for-sql"
  psa_config = {
    ranges = { cloud-sql = "10.60.0.0/16" }
  }
}

resource "google_sql_user" "user" {
  count    = var.create_demo_data ? 1 : 0
  project  = var.project
  name     = "user1"
  instance = module.fake_on_prem_instance[0].name
  password = "changeme"
}

resource "null_resource" "init_db" {
  count = var.create_demo_data ? 1 : 0
  provisioner "local-exec" {
    command = <<EOF
        curl -o cloud-sql-proxy https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.9.0/cloud-sql-proxy.darwin.arm64
        chmod +x cloud-sql-proxy
        nohup ./cloud-sql-proxy ${var.project}:${var.region}:${module.fake_on_prem_instance[0].name} >/dev/null & >/dev/null &
        sleep 3
        psql "host=127.0.0.1 sslmode=disable dbname=postgres user=user1" -f ../sample-data/fake-on-prem-postgresql/sample_db_populator.sql
        PID=$(lsof -i tcp:5432 | grep LISTEN | awk '{print $2}')
        kill -9 $PID
      EOF
  }
  depends_on = [google_sql_user.user]
}

resource "null_resource" "cleanup" {
  count = var.create_demo_data ? 1 : 0
  provisioner "local-exec" {
    when    = destroy
    command = <<EOF
      nohup ./cloud-sql-proxy pso-amex-data-platform:us-central1:fake-on-prem-instance >/dev/null & >/dev/null &
      sleep 3
      psql "host=127.0.0.1 sslmode=disable dbname=postgres user=user1" -f ../sample-data/fake-on-prem-postgresql/cleanup_db.sql
      gcloud compute networks peerings delete servicenetworking-googleapis-com --network=fake-on-prem-network-for-sql
      PID=$(lsof -i tcp:5432 | grep LISTEN | awk '{print $2}')
      kill -9 $PID
      rm cloud-sql-proxy
    EOF
  }
  depends_on = [module.vpc, google_sql_user.user]
}