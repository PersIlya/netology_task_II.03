
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


variable "env"{
  type=string
  default="production" #создавать ли бастион
}

variable "external_acess_bastion"{
  type=bool
  default=true #false true создавать ли бастион
}

#создаем/не создаем бастион
resource "yandex_compute_instance" "bastion" {
  count = alltrue([var.env == "production",var.external_acess_bastion]) ? 1 : 0

  connection {
        type     = "ssh"
        user     = "ubuntu"
        host     = self.network_interface.0.nat_ip_address #можно конечно и yandex_compute_instance.bastion["network_interface"][0]["nat_ip_address"] но не нужно!
        private_key = file("~/.ssh/id_ed25519")
        timeout     = "120s"
  }
  name        = "bastion"  
  hostname    = "bastion" 
  platform_id = "standard-v1"

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = "network-hdd"
      size     = 12
    }
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys = local.ssh_string #"[ ${join("", ["local.ssh", ":",  "local.ssh_key"])} ]"
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
  allow_stopping_for_update = true
}
