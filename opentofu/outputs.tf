
output "frontend_instance_id" {
  value = module.frontend.instance_id
}

output "frontend_public_ip" {
  value = module.frontend.public_ip
}

output "frontend_private_ip" {
  value = module.frontend.private_ip
}

output "backend_instance_id" {
  value = module.backend.instance_id
}

output "backend_public_ip" {
  value = module.backend.public_ip
}

output "backend_private_ip" {
  value = module.backend.private_ip
}
