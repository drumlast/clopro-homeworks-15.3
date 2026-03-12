resource "yandex_storage_bucket" "image_bucket" {
  bucket    = var.bucket_name
  folder_id = var.folder_id

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.bucket_key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "yandex_storage_bucket_grant" "image_bucket_public" {
  bucket = yandex_storage_bucket.image_bucket.bucket

  grant {
    type        = "Group"
    permissions = ["READ"]
    uri         = "http://acs.amazonaws.com/groups/global/AllUsers"
  }
}

resource "yandex_storage_object" "image" {
  bucket = yandex_storage_bucket.image_bucket.bucket
  key    = var.image_file_name
  source = var.image_file_path
}