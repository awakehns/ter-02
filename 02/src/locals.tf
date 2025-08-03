locals {
  vm_names = {
    web = "${var.vm_web_name}-prod"
    db  = "${var.vm_db_name}-prod"
  }
}
