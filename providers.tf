terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.9.7"
}

provider "yandex" {
  #token     = var.token
  cloud_id  = var.YaCloud.cloud_id
  folder_id = var.YaCloud.folder_id
  zone      = var.YaCloud.default_zone
  service_account_key_file = file("~/.authorized_key.json")
}