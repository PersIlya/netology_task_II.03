resource "yandex_compute_instance" "db" {
  depends_on = [ yandex_compute_instance.example ]

  for_each = { for env in local.each_vm : env.vm_name => env } 

  name        =  each.value.vm_name 
  hostname    = "${each.value.vm_name}"
  platform_id = each.value.platform

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.fract
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = each.value.hdd_type
      size     = each.value.disk_size
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
    security_group_ids = [yandex_vpc_security_group.example.id]
  }
  allow_stopping_for_update = true
}