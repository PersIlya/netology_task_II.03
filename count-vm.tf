resource "yandex_compute_instance" "example" {
  count = 2

  name        = "netology-develop-platform-web-${count.index+1}" 
  hostname    = "netology-develop-platform-web-${count.index+1}"
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
    ssh-keys = local.ssh_string #"[ ${join("", ["local.ssh", ":", "local.ssh_key"])} ]"
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = length(yandex_compute_instance.bastion)>0 ? false : true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }
  allow_stopping_for_update = true
}
