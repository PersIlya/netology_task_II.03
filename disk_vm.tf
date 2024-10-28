resource "yandex_compute_disk" "disk" {
  count = 2
  name     = "disk-${count.index+1}" 
  type     = "network-hdd"
  size = 1
}

resource "yandex_compute_instance" "storage" {
  name        = "storage-vm" 
  hostname    = "storage-vm" 
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

  dynamic secondary_disk {
  for_each =  yandex_compute_disk.disk.*.id
    content { disk_id = secondary_disk.value }
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys = local.ssh_string
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = length(yandex_compute_instance.bastion)>0 ? false : true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }
  allow_stopping_for_update = true
}
