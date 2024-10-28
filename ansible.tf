resource "local_file" "options_vm" {
  content = templatefile("${path.module}/hosts.tftpl",
    {
      web = yandex_compute_instance.example
      db  = yandex_compute_instance.db
      storage    = [yandex_compute_instance.storage]
    }
  )
  filename = "${abspath(path.module)}/hosts.cfg"
}