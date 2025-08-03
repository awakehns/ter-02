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
