
output "string" {
    value = "${local.ssh_opt.user_name}:${local.ssh_opt.pubkey}"
}
output "ssh_key" {
    value = "${local.ssh_opt.pubkey}"
}
