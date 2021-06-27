module "app_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/web"
  version = "3.17.0"

  name        = "my-sg"
  description = "Security group for servers"
  vpc_id      = module.vpc.vpc_id
  auto_ingress_rules = ["http-80-tcp","ssh-tcp","nfs-tcp","mysql-tcp"]
 
  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "lb_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/web"
  version = "3.17.0"

  name        = "lb-sg"
  description = "Security group for load balancer"
  vpc_id      = module.vpc.vpc_id

  auto_ingress_rules = ["http-80-tcp","ssh-tcp","nfs-tcp","mysql-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
}