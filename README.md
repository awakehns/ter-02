# Домашнее задание к занятию "`Основы Terraform. Yandex Cloud`" - `Демин Герман`

### Задание 1

`yc iam service-account create --name terraform-sa`

Получил <FOLDER_ID> и <SERVICE_ACCOUNT_ID>, вписываю далее:

```
yc resource-manager folder add-access-binding \
  --id <FOLDER_ID> \
  --role editor \
  --subject serviceAccount:<SERVICE_ACCOUNT_ID>
  
yc iam key create --service-account-id <SERVICE_ACCOUNT_ID> --output key.json

ssh-keygen -t ed25519 -C "awake1394hns@gmail.com"

nano terraform.tfvars
```

```
vms_ssh_public_root_key = <ssh-key>

service_account_key_file = "key.json"

terraform init

terraform validate

eval $(ssh-agent)

ssh-add ~/.ssh/id_ed25519
```

Инициализация кода

![ter-init](/img/ter-init.png)

Ошибки были допущены в названиях переменных, кавычках, и прочие синтаксические ошибки на внимательность. 

terraform validate не обнаружил ошибок после исправления, однако запуска не случилось. Как оказалось, ошибка была в названии переменной var.vms_ssh_root_key в main.tf, хотя в terraform.tfvars переменная называется var.vms_ssh_public_root_key. Исправил.

Также не стартовало из-за того, что была выбрана платформа "standart-v4", и если не считать ошибки в написании, которую я исправил, то данная платформа не поддерживается, есть только v1,v2,v3. Я выбрал v3, после чего получил ошибку, что core_fraction = 5 при данной платформе не поддерживается, а поддерживает только 20,50,100:

![ter-error-1](/img/ter-error-1.png)

Исправил платформу на v1, так как мне не нужны такие мощности на текущий момент. Далее получил ошибку, что 1 ядро недоступно, только 2 или 4. Исправил на 2. После этого запустилось.

Успешный запуск кода

![ter-apply](/img/ter-apply.png)

Добавил ip адрес в outputs.tf:

```
output "web_instance_ip" {
  description = "Внешний IP-адрес ВМ web"
  value       = yandex_compute_instance.platform.network_interface[0].nat_ip_address
}
```

Обновил

`terraform refresh`

Получил ip адрес для подключения

`terraform output web_instance_ip`

`web_instance_ip = "89.169.133.119"`

Подключился по ssh и выполнил curl

```
ssh ubuntu@89.169.133.119

curl ifconfig.me
```

Подключение по ssh

![ter-ssh](/img/ter-ssh.png)

ВМ в yandex cloud

![ya-vm](/img/ya-vm.png)



### Задание 2

Избавляемся от хардкода.
Добавил в variables.tf следующий блок кода:

```
###vm web vars


variable "vm_web_platform_id" {
  type        = string
  description = "ID image"
}

variable "vm_web_family" {
  type        = string
  description = "family"
}

variable "vm_web_name" {
  type        = string
  description = "VM name"
}

variable "vm_web_cores" {
  type        = number
  description = "cores"
}

variable "vm_web_memory" {
  type        = number
  description = "memory"
}

variable "vm_web_fraction" {
  type        = number
  description = "fraction"
}


variable "vm_web_nat" {
  type        = bool
  default     = true
  description = "nat"
}

variable "vm_web_preemptible" {
  type        = bool
  default     = true
  description = "preemptible"
}
```

И добавил соответствующие переменные в terraform.tfvars:

```
vm_web_name = "netology-develop-platform-web"
vm_web_platform_id = "standard-v1"
vm_web_family = "ubuntu-2004-lts"
vm_web_cores = 2
vm_web_memory = 1
vm_web_fraction = 5
vm_web_nat = true
vm_web_preemptible = true
```

`terraform validate`

`terraform plan`

Все верно, изменений нет.

![ter-plan](/img/ter-plan.png)



### Задание 3

Перенес блок переменных первой вм из variable.tf в vms_platform.tf, блоки второй вм добавил в main.tf, vms_platform.tf, terraform.tfvars

`nano main.tf`

```
resource "yandex_compute_instance" "platform_db" {
  name        = var.vm_db_name
  platform_id = var.vm_db_platform_id
  zone        = var.vm_db_zone
  resources {
    cores         = var.vm_db_cores
    memory        = var.vm_db_memory
    core_fraction = var.vm_db_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_db_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_db_nat
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}
```

`nano vms_platform.tf`

```
###vm db vars


variable "vm_db_platform_id" {
  type        = string
  description = "ID image"
}

variable "vm_db_family" {
  type        = string
  description = "family"
}

variable "vm_db_zone" {
  type        = string
  description = "zone"
}

variable "vm_db_name" {
  type        = string
  description = "VM name"
}

variable "vm_db_cores" {
  type        = number
  description = "cores"
}

variable "vm_db_memory" {
  type        = number
  description = "m###vm db vars


variable "vm_db_platform_id" {
  type        = string
  description = "ID image"
}

variable "vm_db_family" {
  type        = string
  description = "family"
}

variable "vm_db_zone" {
  type        = string
  description = "zone"
}

variable "vm_db_name" {
  type        = string
  description = "VM name"
}

variable "vm_db_cores" {
  type        = number
  description = "cores"
}

variable "vm_db_memory" {
  type        = number
  description = "memory"
}

variable "vm_db_fraction" {
  type        = number
  description = "fraction"
}


variable "vm_db_nat" {
  type        = bool
  default     = true
  description = "nat"
}

variable "vm_db_preemptible" {
  type        = bool
  default     = true
  description = "preemptible"
}emory"
}

variable "vm_db_fraction" {
  type        = number
  description = "fraction"
}


variable "vm_db_nat" {
  type        = bool
  default     = true
  description = "nat"
}

variable "vm_db_preemptible" {
  type        = bool
  default     = true
  description = "preemptible"
}
```

`terraform validate`

`terraform plan`

`terraform apply -auto-approve`

Успешное применение кода

![ter-apply-2](/img/ter-apply-2.png)



### Задание 4

`nano output.tf`

```
  GNU nano 8.5                                              outputs.tf                                                       
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
```

Применение кода и вывод информации о ВМ

![ter-output](/img/ter-output.png)



### Задание 5

`nano locals.tf`

```
locals {
  vm_names = {
    web = "${var.vm_web_name}-prod"
    db  = "${var.vm_db_name}-prod"
  }
}
```

`nano main.tf`

```
 name        = local.vm_names.web 
 
 name        = local.vm_names.db
```



### Задание 6

`nano variable.tf`

```
variable "vms_resources" {
  description = "Map of VM resource configs"
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
    hdd_size      = number
    hdd_type      = string
  }))
}

variable "metadata" {
  description = "Common metadata for all VMs"
  type = map(any)
}
```

`nano terraform.tfvars`

```
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
  "ssh-keys"           = <ssh-key>
}
```

`terraform validate`

`terraform plan`

План показывает пересоздание vm из-за изменения типа дисков и размера, так как до этого мы их не указывали и по умолчанию объем дисков был 5 ГБ на обеих ВМ. Пересоздаю.

`terraform apply -auto-approve`

Успешное применение кода

![ter-apply-3](/img/ter-apply-3.png)

Конечный код:

main.tf

```
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
```

variables.tf

```
###cloud vars


variable "vms_resources" {
  description = "Map of VM resource configs"
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
    hdd_size      = number
    hdd_type      = string
  }))
}

variable "metadata" {
  description = "Common metadata for all VMs"
  type = map(any)
}


variable "image_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "network_develop_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

variable "subnet_a_name" {
  type        = string
  default     = "a"
  description = "subnet b zone"
}

variable "subnet_b_name" {
  type        = string
  default     = "b"
  description = "subnet b zone"
}

variable "subnet_b_zone" {
  type        = string
  description = "subnet b zone"
}

variable "subnet_b_cidr" {
  type        = list(string)
  description = "subnet b cidr"
}

#variable "vms_ssh_root_key" {
#  type        = string
#  description = "ssh-keygen -t ed25519"
#}

variable "service_account_key_file" {
  description = "path to key.json"
  type        = string
}
```

outputs.tf

```
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
```

locals.tf

```
locals {
  vm_names = {
    web = "${var.vm_web_name}-prod"
    db  = "${var.vm_db_name}-prod"
  }
}

```

vms_platform.tf

```

###vm web vars


variable "vm_web_platform_id" {
  type        = string
  description = "ID image"
}

variable "vm_web_family" {
  type        = string
  description = "family"
}

variable "vm_web_name" {
  type        = string
  description = "VM name"
}

#variable "vm_web_cores" {
#  type        = number
#  description = "cores"
#}

#variable "vm_web_memory" {
#  type        = number
#  description = "memory"
#}

#variable "vm_web_fraction" {
#  type        = number
#  description = "fraction"
#}


variable "vm_web_nat" {
  type        = bool
  default     = true
  description = "nat"
}

variable "vm_web_preemptible" {
  type        = bool
  default     = true
  description = "preemptible"
}



###vm db vars


variable "vm_db_platform_id" {
  type        = string
  description = "ID image"
}

variable "vm_db_family" {
  type        = string
  description = "family"
}

variable "vm_db_zone" {
  type        = string
  description = "zone"
}

variable "vm_db_name" {
  type        = string
  description = "VM name"
}

#variable "vm_db_cores" {
#  type        = number
#  description = "cores"
#}

#variable "vm_db_memory" {
#  type        = number
#  description = "memory"
#}

#variable "vm_db_fraction" {
#  type        = number
#  description = "fraction"
#}


variable "vm_db_nat" {
  type        = bool
  default     = true
  description = "nat"
}

variable "vm_db_preemptible" {
  type        = bool
  default     = true
  description = "preemptible"
}
```
