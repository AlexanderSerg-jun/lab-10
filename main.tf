locals {
  vm_user         = "debian"
  ssh_public_key  = "~/.ssh/id_rsa.pub"
  ssh_private_key = "~/.ssh/id_rsa"

  proxmox_host  = "pve-01"
  template_name = "debian-12-generic-amd64"

  dbs_count = "1"
  bes_count = "1"
  lbs_count = "1"
}

resource "proxmox_vm_qemu" "dbs" {
  count = local.dbs_count
  name = "db-${format("%02d", count.index + 1)}"
  desc = "Database Debian Server"
  #vmid = "40${count.index + 1}"
  target_node = local.proxmox_host
  clone = local.template_name
  size  = "10G"
  agent = 1
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 1024
  onboot = true

  network {
    bridge = "vmbr0"
    model = "virtio"
  }

  disk {
    storage = "local-lvm"
    type = "virtio"
    size = "5G"
  }

  os_type = "cloud-init"
  ipconfig0 = "ip=192.168.117.4${count.index + 1}/24,gw=192.168.117.1"
  #nameserver = "192.168.117.1"
  ciuser = local.vm_user
  sshkeys = file(local.ssh_public_key)
}

resource "proxmox_vm_qemu" "bes" {
  count = local.bes_count
  name = "be-${format("%02d", count.index + 1)}"
  desc = "Backend Debian Server"
  #vmid = "40${count.index + 1}"
  target_node = local.proxmox_host
  clone = local.template_name
  size  = "10G"
  agent = 1
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 1024
  onboot = true

  network {
    bridge = "vmbr0"
    model = "virtio"
  }

  disk {
    storage = "local-lvm"
    type = "virtio"
    size = "5G"
  }

  os_type = "cloud-init"
  ipconfig0 = "ip=192.168.117.5${count.index + 1}/24,gw=192.168.117.1"
  #nameserver = "192.168.117.1"
  ciuser = local.vm_user
  sshkeys = file(local.ssh_public_key)
}

resource "proxmox_vm_qemu" "lbs" {
  count = local.lbs_count
  name = "lb-${format("%02d", count.index + 1)}"
  desc = "LoadBalance Debian Server"
  #vmid = "40${count.index + 1}"
  target_node = local.proxmox_host
  clone = local.template_name
  size  = "10G"
  agent = 1
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 1024
  onboot = true

  network {
    bridge = "vmbr0"
    model = "virtio"
  }

  disk {
    storage = "local-lvm"
    type = "virtio"
    size = "5G"
  }

  os_type = "cloud-init"
  ipconfig0 = "ip=192.168.117.6${count.index + 1}/24,gw=192.168.117.1"
  #nameserver = "192.168.117.1"
  ciuser = local.vm_user
  sshkeys = file(local.ssh_public_key)
}

resource "local_file" "inventory_file" {
  content = templatefile("${path.module}/templates/inventory.tpl",
    {
      dbs    = proxmox_vm_qemu.dbs[*]
      bes    = proxmox_vm_qemu.bes[*]
      lbs    = proxmox_vm_qemu.lbs[*]
    }
  )
  filename = "${path.module}/inventory.ini"
}




/*
resource "null_resource" "nginx-servers" {

  count = length(module.nginx-servers)

  # Changes to the instance will cause the null_resource to be re-executed
  triggers = {
    name = module.nginx-servers[count.index].vm_name
  }

  
  # Running the remote provisioner like this ensures that ssh is up and running
  # before running the local provisioner

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]
  }

  connection {
    type        = "ssh"
    user        = local.vm_user
    private_key = file(local.ssh_private_key)
    host        = "${module.nginx-servers[count.index].instance_external_ip_address}"
  }

  # Note that the -i flag expects a comma separated list, so the trailing comma is essential!

  provisioner "local-exec" {
    command = "ansible-playbook -u '${local.vm_user}' --private-key '${local.ssh_private_key}' --become -i ./inventory.ini -l '${module.nginx-servers[count.index].instance_external_ip_address},' provision.yml"
    #command = "ansible-playbook provision.yml -u '${local.vm_user}' --private-key '${local.ssh_private_key}' --become -i '${element(module.nginx-servers.nat_ip_address, 0)},' "
  }
  
}
*/
/*
resource "null_resource" "backend-servers" {

  count = length(module.backend-servers)

  # Changes to the instance will cause the null_resource to be re-executed
  triggers = {
    name = "${module.backend-servers[count.index].vm_name}"
  }

  # Running the remote provisioner like this ensures that ssh is up and running
  # before running the local provisioner

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]
  }

  connection {
    type        = "ssh"
    user        = local.vm_user
    private_key = file(local.ssh_private_key)
    host        = "${module.backend-servers[count.index].instance_external_ip_address}"
  }

  # Note that the -i flag expects a comma separated list, so the trailing comma is essential!

  provisioner "local-exec" {
    command = "ansible-playbook -u '${local.vm_user}' --private-key '${local.ssh_private_key}' --become -i '${module.backend-servers[count.index].instance_external_ip_address},' provision.yml"
    #command = "ansible-playbook provision.yml -u '${local.vm_user}' --private-key '${local.ssh_private_key}' --become -i '${element(module.backend-servers.nat_ip_address, 0)},' "
  }
}
*/
