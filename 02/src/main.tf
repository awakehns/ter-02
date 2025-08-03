resource "yandex_vpc_network" "develop" {
  name = var.network_develop_name
}

resource "yandex_vpc_subnet" "a" {
  name           = var.subnet_a_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}
resource "yandex_vpc_subnet" "b" {
  name           = var.subnet_b_name
  zone           = var.subnet_b_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.subnet_b_cidr
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_family
}
resource "yandex_compute_instance" "platform_web" {
  name        = local.vm_names.web
  platform_id = var.vm_web_platform_id
  resources {
    cores         = var.vms_resources["web"].cores
    memory        = var.vms_resources["web"].memory
    core_fraction = var.vms_resources["web"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size = var.vms_resources["web"].hdd_size
      type = var.vms_resources["web"].hdd_type
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.a.id
    nat       = var.vm_web_nat
  }

  metadata = var.metadata

}

resource "yandex_compute_instance" "platform_db" {
  name        = local.vm_names.db
  platform_id = var.vm_db_platform_id
  zone        = var.vm_db_zone
  resources {
    cores         = var.vms_resources["db"].cores
    memory        = var.vms_resources["db"].memory
    core_fraction = var.vms_resources["db"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size = var.vms_resources["db"].hdd_size
      type = var.vms_resources["db"].hdd_type
    }
  }
  scheduling_policy {
    preemptible = var.vm_db_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.b.id
    nat       = var.vm_db_nat
  }

  metadata = var.metadata

}
