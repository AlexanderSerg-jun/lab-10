variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
  sensitive = true
}

variable "proxmox_api_token_secret" {
  type = string
  sensitive = true
}

variable "domain_name" {
  type = string
}





variable "ssh_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCgaU3Ra1Wi5CNimg/P3tYlCPosUzAZw6D5t3yo7ZF0ZqHYHWMmvmtgHSl+NL04VCY444Yyysuy+F0797DxJCv2RhE1aEoukPYKvr/T9eMVwlb0m+Euqqux/XVSt+s0iL8ylK+5bozzEESoOgRhIToEGtp72GDBCnN2i0f2QFwwJIdf6d6L2AsO0FrxmpcSofdiG4e/C9wNlSBEEdtS+0munB+FNhezsHn0jXcihrULA2jozUg1YzjujIMQyZ6wyk6KokasbiL2rPUcVMC7/oHpoQo/qpewn6cN1xqyQVokbyqiE6X8jxYkM8gykPaR6lvZKKAwJf4gNOxa+U/TLSB2Pgfo+tkqFse0L0drJUCTzwc+0WfMDXKde0OSnO4+pnKx9YUvz/9GzhaFTKgudfRDyj0TlgjgFowVngfriL63NoXQLIJloh9uj3htTCg68ywKhJ5eL/6pSn9DwvbIZCM0nRIhoxNdsqkYjddTe05p95aZwc0Y7TI7/0SBsq1nzpE= user@redos"
}
variable "proxmox_host" {
    default = "prox-1u"
}
variable "template_name" {
    default = "ubuntu-2004-cloudinit-template"
}