resource "yandex_compute_instance" "example" {
  count = 2
  
  name        = "${local.count_vm.name}-${count.index+1}" 
  hostname    = "${local.count_vm.name}-${count.index+1}" 
  platform_id = local.count_vm.platform

  resources {
    cores         = local.count_vm.cpu
    memory        = local.count_vm.ram
    core_fraction = local.count_vm.fract
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = local.count_vm.hdd_type
      size     = local.count_vm.disk_size
    }
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
