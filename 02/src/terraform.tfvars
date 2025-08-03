service_account_key_file = "key.json"
cloud_id                 = "ajeq7qfcr9onsv91vmdn"
folder_id                = "b1g7stsus4dh2i69fd1n"
image_id                 = "f2ef6jide8f1cj8dcbun"
subnet_id                = "e9bnr8d0hba4dp28dpgt"
subnet_b_zone = "ru-central1-b"
subnet_b_cidr = ["10.0.2.0/24"]

vm_web_name = "netology-develop-platform-web"
vm_web_platform_id = "standard-v1"
vm_web_family = "ubuntu-2004-lts"
vm_web_nat = true
vm_web_preemptible = true

vm_db_name = "netology-develop-platform-db"
vm_db_platform_id = "standard-v1"
vm_db_family = "ubuntu-2004-lts"
vm_db_zone = "ru-central1-b"
vm_db_nat = true
vm_db_preemptible = true


vms_resources = {
  web = {
    cores         = 2
    memory        = 1
    core_fraction = 5
    hdd_size      = 10
    hdd_type      = "network-hdd"
  },
  db = {
    cores         = 2
    memory        = 2
    core_fraction = 20
    hdd_size      = 10
    hdd_type      = "network-ssd"
  }
}

metadata = {
  "serial-port-enable" = "1"
  "ssh-keys"           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICrIfXstAe/twbqXxGX9Ev6gOEV6suCO617dU0xck+yC awake1394hns@gmail.com"
}
