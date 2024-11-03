resource "yandex_compute_disk" "disk" {
  count = 2
  name     = "${local.disk_vm.opt_disk_name}-${count.index+1}" 
  type     = local.disk_vm.hdd_type
  size = local.disk_vm.opt_disk_size
}

resource "yandex_compute_instance" "storage" {
  name        = local.disk_vm.name 
  hostname    = local.disk_vm.name 
  platform_id = local.disk_vm.platform

  resources {
    cores         = local.disk_vm.cpu
    memory        = local.disk_vm.ram
    core_fraction = local.disk_vm.fract
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = local.disk_vm.hdd_type
      size     = local.disk_vm.disk_size
    }
  }

  dynamic secondary_disk {
  for_each =  yandex_compute_disk.disk.*.id
    content { disk_id = secondary_disk.value }
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys = "${local.ssh_opt.user_name}:${local.ssh_opt.pubkey}"
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = length(yandex_compute_instance.bastion)>0 ? false : true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }
  allow_stopping_for_update = true
}
