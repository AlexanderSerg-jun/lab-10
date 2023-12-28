
output "dbs-info" {
  description = "General information about created VMs"
  value = {
    for vm in proxmox_vm_qemu.dbs[*] :
    vm.name => {
      ip_address = vm.default_ipv4_address
    }
  }
}

output "bes-info" {
  description = "General information about created VMs"
  value = {
    for vm in proxmox_vm_qemu.dbs[*] :
    vm.name => {
      ip_address = vm.default_ipv4_address
    }
  }
}

output "lbs-info" {
  description = "General information about created VMs"
  value = {
    for vm in proxmox_vm_qemu.dbs[*] :
    vm.name => vm
  }
}
