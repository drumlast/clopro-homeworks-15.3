output "bucket_name" {
  value = yandex_storage_bucket.image_bucket.bucket
}

output "image_url" {
  value = "https://${yandex_storage_bucket.image_bucket.bucket}.storage.yandexcloud.net/${yandex_storage_object.image.key}"
}

output "nlb_ip" {
  value = one([
    for listener in yandex_lb_network_load_balancer.lamp_nlb.listener :
    one([
      for addr in listener.external_address_spec : addr.address
    ])
  ])
}

output "instance_group_id" {
  value = yandex_compute_instance_group.lamp_group.id
}

output "kms_key_id" {
  value = yandex_kms_symmetric_key.bucket_key.id
}