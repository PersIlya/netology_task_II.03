locals {
  Name_VPC="${yandex_vpc_network.develop.name}-${var.YaCloud.default_zone}"

  count_vm = { name="netology-develop-platform-web", platform="standard-v1", cpu=2, ram=1, fract=20, hdd_type="network-hdd", disk_size=12 } 

  disk_vm = { name="storage-vm", platform="standard-v1", cpu=2, ram=1, fract=20, hdd_type="network-hdd", disk_size=12, opt_disk_name="disk", opt_disk_size=1 } 

  bastion_opt ={env="production", external_acess_bastion=true}
  bastion_vm = {name="bastion", platform="standard-v1", cpu=2, ram=1, fract=20, hdd_type="network-hdd", disk_size=12} 
  
  each_vm = [ 
      { vm_name="main", platform="standard-v1", cpu=2, ram=1, fract=20, hdd_type="network-hdd", disk_size=12 } ,
      { vm_name="replica", platform="standard-v1", cpu=4, ram=2, fract=20, hdd_type="network-hdd", disk_size=15 }  
  ] 

  ssh_opt = {proto="ssh", user_name="ubuntu", pubkey=file("~/.ssh/id_ed25519.pub"), time="120s"}
}