# Create data storage bucket.
resource "google_storage_bucket" "data_buckets" {
  for_each    = var.create_data_buckets ? var.data_buckets : {}
  name                     = each.value.name
  location                 = each.value.region
  project                  = each.value.project
  public_access_prevention = "enforced"
  force_destroy            = false
}

# Create bucket containing DDLs.
resource "google_storage_bucket" "ddl_buckets" {
  for_each    = var.create_ddl_buckets ? var.ddl_buckets : {}
  name                     = each.value.bucket_name
  location                 = each.value.bucket_region
  project                  = each.value.bucket_project
  public_access_prevention = "enforced"
  force_destroy            = false
}