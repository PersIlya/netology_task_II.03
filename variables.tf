###cloud vars
/*
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}
*/

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

###########################################################################
variable "YaCloud" {
  description = "YaCloud options"
  type = object({cloud_id=string, folder_id=string, default_zone=string, default_cidr = list(string)})
  sensitive = true
}

/*
variable "global_metadata" {
  description = "Global metadata for connect"
  type = object({serial-port-enable = string, ssh-keys = string})
  sensitive = true
}
*/

variable "vms_resources" {
  description = "Global VMs resources"
  type = map(object(
    {
      cores = number
      memory = number
      core_fraction = number
    }
  ))
} 

variable "vms_net_options" {
  description = "VMs net options"
  type = map(object(
    {
      default_zone = string
      default_cidr = list(string)
      vpc_name = string
    }
  ))
} 