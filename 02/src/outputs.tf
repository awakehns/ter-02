output "instances_info" {
  value = [
    for instance in [
      yandex_compute_instance.platform_web,
      yandex_compute_instance.platform_db
    ] : {
      instance_name = instance.name
      external_ip   = instance.network_interface[0].nat_ip_address
      fqdn          = instance.fqdn
    }
  ]
}

