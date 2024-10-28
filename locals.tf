locals {
   Name_VPC="${yandex_vpc_network.develop.name}-${var.YaCloud.default_zone}"

   each_vm = [ 
      { vm_name="main", cpu=2, ram=1, disk_size=12 } ,
      { vm_name="replica", cpu=4, ram=2, disk_size=15 }  
  ] 

#ssh_user = "ubuntu"
  ssh_key =  file("~/.ssh/id_ed25519.pub")
#ssh_string= "[${join("", ["${local.ssh_user}", ":", "${local.ssh_key}"])}]"
  ssh_string= "ubuntu:${local.ssh_key}"
}