variable "token" {
  type        = string
  description = "Yandex Cloud token"
  sensitive   = true
}

variable "cloud_id" {
  type        = string
  description = "Yandex Cloud ID"
}

variable "folder_id" {
  type        = string
  description = "Yandex Folder ID"
}

variable "zone" {
  type        = string
  description = "YC zone"
  default     = "ru-central1-a"
}

variable "ssh_user" {
  type        = string
  description = "SSH user name"
  default     = "ubuntu"
}

variable "public_key_path" {
  type        = string
  description = "Path to public SSH key"
}

variable "bucket_name" {
  type        = string
  description = "Object Storage bucket name"
}

variable "image_file_path" {
  type        = string
  description = "Path to local image file"
}

variable "image_file_name" {
  type        = string
  description = "Name of image in bucket"
  default     = "image.jpg"
}