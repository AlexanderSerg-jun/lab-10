locals {
  vm_user         = "almalinux"
  ssh_public_key  = "~/.ssh/id_rsa.pub"
  ssh_private_key = "~/.ssh/id_rsa"
  #vm_name         = "instance"
  vpc_name        = "my_vpc_network"

  folders = {
    "lab-folder" = {}
  }

  subnets = {
    "lab-subnet" = {
      v4_cidr_blocks = ["10.10.10.0/24"]
    }
  }

  #subnet_cidrs  = ["10.10.50.0/24"]
  #subnet_name   = "my_vpc_subnet"
  jump_count     = "0"
  db_count       = "1"
  iscsi_count    = "1"
  backend_count  = "2"
  nginx_count    = "2"
  /*
  disk = {
    "web" = {
      "size" = "1"
    }
  }
  */
}
/*
resource "yandex_vpc_network" "vpc" {
  folder_id = yandex_resourcemanager_folder.folders["lab-folder"].id
  name      = local.vpc_name
}

resource "yandex_vpc_subnet" "subnets" {
  for_each = local.subnets
  name           = each.key
  folder_id      = yandex_resourcemanager_folder.folders["lab-folder"].id
  v4_cidr_blocks = each.value["v4_cidr_blocks"]
  zone           = var.zone
  network_id     = data.yandex_vpc_network.vpc.id
  route_table_id = yandex_vpc_route_table.rt.id
}
*/
/*
resource "proxmox_vm_qemu" "srv_demo_1" {
  name = "srv-demo-1"
  #desc = "Ubuntu Server"
  #vmid = "401"
  target_node = "pve"
  iso = "/root/debian-12.4.0-amd64-netinst.iso"

  agent = 1

  #clone = "debian-server-focal"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 2048

  network {
    bridge = "vmbr0"
    model = "virtio"
  }

  disk {
    storage = "local-lvm"
    type = "virtio"
    size = "20G"
  }
  os_type = "debian"

  ipconfig0 = "ip=10.10.10.11/24,gw=10.10.10.1"
  nameserver = "10.10.10.1"
  ciuser = "debian"
  sshkeys = <<EOF
  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCgaU3Ra1Wi5CNimg/P3tYlCPosUzAZw6D5t3yo7ZF0ZqHYHWMmvmtgHSl+NL04VCY444Yyysuy+F0797DxJCv2RhE1aEoukPYKvr/T9eMVwlb0m+Euqqux/XVSt+s0iL8ylK+5bozzEESoOgRhIToEGtp72GDBCnN2i0f2QFwwJIdf6d6L2AsO0FrxmpcSofdiG4e/C9wNlSBEEdtS+0munB+FNhezsHn0jXcihrULA2jozUg1YzjujIMQyZ6wyk6KokasbiL2rPUcVMC7/oHpoQo/qpewn6cN1xqyQVokbyqiE6X8jxYkM8gykPaR6lvZKKAwJf4gNOxa+U/TLSB2Pgfo+tkqFse0L0drJUCTzwc+0WfMDXKde0OSnO4+pnKx9YUvz/9GzhaFTKgudfRDyj0TlgjgFowVngfriL63NoXQLIJloh9uj3htTCg68ywKhJ5eL/6pSn9DwvbIZCM0nRIhoxNdsqkYjddTe05p95aZwc0Y7TI7/0SBsq1nzpE= user@redos
  EOF

}
*/
/*
resource "proxmox_vm_qemu" "preprovision-test" {
  #preprovision      = true
  os_type           = "ubuntu"
  agent             = 0
  boot              = "order=net0;scsi0"
  pxe               = true
  target_node       = "pve"
  ssh_forward_ip    = "10.0.0.1"
  ssh_user          = "terraform"
  ssh_private_key   = <<EOF
-----BEGIN RSA PRIVATE KEY-----
private ssh key terraform
-----END RSA PRIVATE KEY-----
EOF
  os_network_config = <<EOF
auto eth0
iface eth0 inet dhcp
EOF

  connection {
    type        = "ssh"
    user        = "${self.ssh_user}"
    private_key = "${self.ssh_private_key}"
    host        = "${self.ssh_host}"
    port        = "${self.ssh_port}"
  }
}
*/
/*
resource "proxmox_vm_qemu" "pxe-minimal-example" {
    name                      = "pxe-minimal-example"
    agent                     = 0
    boot                      = "order=net0;scsi0"
    pxe                       = true
    target_node               = "test"
    network {
        bridge    = "vmbr0"
        firewall  = false
        link_down = false
        model     = "e1000"
    }
}
*/
/*
resource "proxmox_vm_qemu" "test_server" {
  count = 1 # just want 1 for now, set to 0 and apply to destroy VM
  name = "test-vm-${count.index + 1}" #count.index starts at 0, so + 1 means this VM will be named test-vm-1 in proxmox
  # this now reaches out to the vars file. I could've also used this var above in the pm_api_url setting but wanted to spell it out up there. target_node is different than api_url. target_node is which node hosts the template and thus also which node will host the new VM. it can be different than the host you use to communicate with the API. the variable contains the contents "prox-1u"
  target_node = var.proxmox_host
  # another variable with contents "ubuntu-2004-cloudinit-template"
  clone = var.template_name
  # basic VM settings here. agent refers to guest agent
  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 2048
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"
  disk {
    slot = 0
    # set disk size here. leave it small for testing because expanding the disk takes time.
    size = "10G"
    type = "scsi"
    storage = "local-zfs"
    iothread = 1
  }
  
  # if you want two NICs, just copy this whole network section and duplicate it
  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  # not sure exactly what this is for. presumably something about MAC addresses and ignore network changes during the life of the VM
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
  
  # the ${count.index + 1} thing appends text to the end of the ip address
  # in this case, since we are only adding a single VM, the IP will
  # be 10.98.1.91 since count.index starts at 0. this is how you can create
  # multiple VMs and have an IP assigned to each (.91, .92, .93, etc.)
  ipconfig0 = "ip=10.98.1.9${count.index + 1}/24,gw=10.98.1.1"
  
  # sshkeys set using variables. the variable contains the text of the key.
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}
*/

resource "proxmox_vm_qemu" "ressource_testvm" {
    desc        = "VM test Server"
    name        = "test"
    target_node = "pve" #Internal name of your proxmox server
    #cores       = 2
    #sockets     = 2
    #onboot      = true
    #numa        = true
    #hotplug     = "network,disk,usb"
    #iso         = "/tmp/debian-12.4.0-amd64-netinst.iso"  #replace vms2 with real datastore name
    iso         = "./debian.iso"  #replace vms2 with real datastore name
    #memory      = 2048
    #balloon     = 2048
    #scsihw      = "virtio-scsi-pci"
    #bootdisk    = "scsi0"
  /*
    disk {
      size        = "10G"
      storage     = "vms"
      type        = "scsi"
    }
  
    network {
      bridge    = "vmbr1"
      model     = "virtio"
    }
  */
  }














/*

module "jump-servers" {
  source         = "./modules/instances"
  count          = local.jump_count
  vm_name        = "jump-${format("%02d", count.index + 1)}"
  vpc_name       = local.vpc_name
  folder_id      = yandex_resourcemanager_folder.folders["lab-folder"].id
  network_interface = {
    for subnet in yandex_vpc_subnet.subnets :
    subnet.name => {
      subnet_id = subnet.id
      nat       = true
    }
    if subnet.name == "lab-subnet"
  }
  #subnet_cidrs   = yandex_vpc_subnet.subnet.v4_cidr_blocks
  #subnet_name    = yandex_vpc_subnet.subnet.name
  #subnet_id      = yandex_vpc_subnet.subnet.id
  vm_user        = local.vm_user
  ssh_public_key = local.ssh_public_key
  secondary_disk = {}
  depends_on     = [yandex_compute_disk.disks]
}

data "yandex_compute_instance" "jump-servers" {
  count      = length(module.jump-servers)
  name       = module.jump-servers[count.index].vm_name
  folder_id  = yandex_resourcemanager_folder.folders["lab-folder"].id
  depends_on = [module.jump-servers]
}

module "db-servers" {
  source         = "./modules/instances"
  count          = local.db_count
  vm_name        = "db-${format("%02d", count.index + 1)}"
  vpc_name       = local.vpc_name
  folder_id      = yandex_resourcemanager_folder.folders["lab-folder"].id
  network_interface = {
    for subnet in yandex_vpc_subnet.subnets :
    subnet.name => {
      subnet_id = subnet.id
      #nat       = true
    }
    if subnet.name == "lab-subnet"
  }
  #subnet_cidrs   = yandex_vpc_subnet.subnet.v4_cidr_blocks
  #subnet_name    = yandex_vpc_subnet.subnet.name
  #subnet_id      = yandex_vpc_subnet.subnet.id
  vm_user        = local.vm_user
  ssh_public_key = local.ssh_public_key
  secondary_disk = {}
  depends_on     = [yandex_compute_disk.disks]
}

data "yandex_compute_instance" "db-servers" {
  count      = length(module.db-servers)
  name       = module.db-servers[count.index].vm_name
  folder_id  = yandex_resourcemanager_folder.folders["lab-folder"].id
  depends_on = [module.db-servers]
}

module "iscsi-servers" {
  source         = "./modules/instances"
  count          = local.iscsi_count
  vm_name        = "iscsi-${format("%02d", count.index + 1)}"
  vpc_name       = local.vpc_name
  folder_id      = yandex_resourcemanager_folder.folders["lab-folder"].id
  network_interface = {
    for subnet in yandex_vpc_subnet.subnets :
    subnet.name => {
      subnet_id = subnet.id
      #nat       = true
    }
    if subnet.name == "lab-subnet" #|| subnet.name == "backend-subnet"
  }
  #subnet_cidrs   = yandex_vpc_subnet.subnet.v4_cidr_blocks
  #subnet_name    = yandex_vpc_subnet.subnet.name
  #subnet_id      = yandex_vpc_subnet.subnet.id
  vm_user        = local.vm_user
  ssh_public_key = local.ssh_public_key
  secondary_disk = {
    for disk in yandex_compute_disk.disks :
    disk.name => {
      disk_id = disk.id
      #"auto_delete" = true
      #"mode"        = "READ_WRITE"
    }
    if disk.name == "web-${format("%02d", count.index + 1)}"
  }
  depends_on = [yandex_compute_disk.disks]
}

data "yandex_compute_instance" "iscsi-servers" {
  count      = length(module.iscsi-servers)
  name       = module.iscsi-servers[count.index].vm_name
  folder_id  = yandex_resourcemanager_folder.folders["lab-folder"].id
  depends_on = [module.iscsi-servers]
}

module "backend-servers" {
  source         = "./modules/instances"
  count          = local.backend_count
  vm_name        = "backend-${format("%02d", count.index + 1)}"
  vpc_name       = local.vpc_name
  folder_id      = yandex_resourcemanager_folder.folders["lab-folder"].id
  network_interface = {
    for subnet in yandex_vpc_subnet.subnets :
    subnet.name => {
      subnet_id = subnet.id
      #nat       = true
    }
    if subnet.name == "lab-subnet" #|| subnet.name == "backend-subnet"
  }
  #subnet_cidrs   = yandex_vpc_subnet.subnet.v4_cidr_blocks
  #subnet_name    = yandex_vpc_subnet.subnet.name
  #subnet_id      = yandex_vpc_subnet.subnet.id
  vm_user        = local.vm_user
  ssh_public_key = local.ssh_public_key
  secondary_disk = {}
  depends_on = [yandex_compute_disk.disks]
}

data "yandex_compute_instance" "backend-servers" {
  count      = length(module.backend-servers)
  name       = module.backend-servers[count.index].vm_name
  folder_id  = yandex_resourcemanager_folder.folders["lab-folder"].id
  depends_on = [module.backend-servers]
}

module "nginx-servers" {
  source         = "./modules/instances"
  count          = local.nginx_count
  vm_name        = "nginx-${format("%02d", count.index + 1)}"
  vpc_name       = local.vpc_name
  folder_id      = yandex_resourcemanager_folder.folders["lab-folder"].id
  network_interface = {
    for subnet in yandex_vpc_subnet.subnets :
    subnet.name => {
      subnet_id = subnet.id
      nat       = true
    }
    if subnet.name == "lab-subnet" #|| subnet.name == "nginx-subnet"
  }
  #subnet_cidrs   = yandex_vpc_subnet.subnet.v4_cidr_blocks
  #subnet_name    = yandex_vpc_subnet.subnet.name
  #subnet_id      = yandex_vpc_subnet.subnet.id
  vm_user        = local.vm_user
  ssh_public_key = local.ssh_public_key
  secondary_disk = {}
  depends_on     = [yandex_compute_disk.disks]
}

data "yandex_compute_instance" "nginx-servers" {
  count      = length(module.nginx-servers)
  name       = module.nginx-servers[count.index].vm_name
  folder_id  = yandex_resourcemanager_folder.folders["lab-folder"].id
  depends_on = [module.nginx-servers]
}

resource "local_file" "inventory_file" {
  content = templatefile("${path.module}/templates/inventory.tpl",
    {
      jump-servers    = data.yandex_compute_instance.jump-servers
      db-servers      = data.yandex_compute_instance.db-servers
      iscsi-servers   = data.yandex_compute_instance.iscsi-servers
      backend-servers = data.yandex_compute_instance.backend-servers
      nginx-servers   = data.yandex_compute_instance.nginx-servers
      consul-servers  = data.yandex_compute_instance.consul-servers
      remote_user     = local.vm_user
      domain_name     = var.domain_name
      domain_org      = var.domain_org
      domain_token    = var.yc_token
    }
  )
  filename = "${path.module}/inventory.ini"
}
#resource "yandex_compute_disk" "disks" {
#  for_each  = local.disks
#  name      = each.key
#  folder_id = yandex_resourcemanager_folder.folders["lab-folder"].id
#  size      = each.value["size"]
#  zone      = var.zone
#}

resource "yandex_compute_disk" "disks" {
  count     = local.iscsi_count
  name      = "web-${format("%02d", count.index + 1)}"
  folder_id = yandex_resourcemanager_folder.folders["lab-folder"].id
  size      = "1"
  zone      = var.zone
}
*/
#data "yandex_compute_disk" "disks" {
#  for_each   = yandex_compute_disk.disks
#  name       = each.value["name"]
#  folder_id  = yandex_resourcemanager_folder.folders["lab-folder"].id
#  depends_on = [yandex_compute_disk.disks]
#}
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
