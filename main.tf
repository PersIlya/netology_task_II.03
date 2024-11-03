
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop" {
  name           = local.Name_VPC
  zone           = var.YaCloud.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.YaCloud.default_cidr
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

#создаем/не создаем бастион
resource "yandex_compute_instance" "bastion" {
  count = alltrue([local.bastion_opt.env == "production",local.bastion_opt.external_acess_bastion]) ? 1 : 0

  connection {
        type     = local.ssh_opt.proto
        user     = local.ssh_opt.user_name
        host     = self.network_interface.0.nat_ip_address #можно конечно и yandex_compute_instance.bastion["network_interface"][0]["nat_ip_address"] но не нужно!
        private_key = local.ssh_opt.pubkey #file("~/.ssh/id_ed25519")
        timeout     = local.ssh_opt.time
  }
  name        = local.bastion_vm.name  
  hostname    = local.bastion_vm.name 
  platform_id = local.bastion_vm.platform

  resources {
    cores         = local.bastion_vm.cpu
    memory        = local.bastion_vm.ram
    core_fraction = local.bastion_vm.fract
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = local.bastion_vm.hdd_type
      size     = local.bastion_vm.disk_size
    }
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys = "${local.ssh_opt.user_name}:${local.ssh_opt.pubkey}"
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
  allow_stopping_for_update = true
}
