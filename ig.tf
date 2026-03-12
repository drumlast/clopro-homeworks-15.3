locals {
  image_url = "https://${yandex_storage_bucket.image_bucket.bucket}.storage.yandexcloud.net/${yandex_storage_object.image.key}"

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y apache2

    cat > /var/www/html/index.html <<HTML
    <!DOCTYPE html>
    <html>
    <head>
      <title>Yandex Cloud HW</title>
    </head>
    <body>
      <h1>Instance Group работает</h1>
      <p>Картинка из Object Storage:</p>
      <img src="${local.image_url}" alt="bucket image" width="500">
    </body>
    </html>
    HTML

    systemctl enable apache2
    systemctl restart apache2
  EOF
}

resource "yandex_compute_instance_group" "lamp_group" {
  name               = "lamp-group"
  folder_id          = var.folder_id
  service_account_id = yandex_iam_service_account.ig_sa.id

  instance_template {
    platform_id = "standard-v3"

    resources {
      cores  = 2
      memory = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
        size     = 15
      }
    }

    network_interface {
      network_id = yandex_vpc_network.main.id
      subnet_ids = [yandex_vpc_subnet.public.id]
      nat        = true
    }

    metadata = {
      ssh-keys  = "${var.ssh_user}:${file(pathexpand(var.public_key_path))}"
      user-data = local.user_data
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.zone]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  health_check {
    http_options {
      port = 80
      path = "/"
    }
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  load_balancer {
    target_group_name        = "lamp-target-group"
    target_group_description = "Target group for lamp instance group"
  }
}
resource "yandex_iam_service_account" "ig_sa" {
  name = "lamp-ig-sa"
}

resource "yandex_resourcemanager_folder_iam_member" "ig_sa_editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.ig_sa.id}"
}