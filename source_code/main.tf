module "network" {
  source      = "./modules/network"
  application = var.application
  environment = var.environment
}

module "application" {
  source = "./modules/ec2"
  application = var.application
  environment = var.environment
  subnet_id = module.network.public_subnet_id1
  security_group = module.network.security_group_id
  associate_public_ip_address = true
}