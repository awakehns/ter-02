
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
