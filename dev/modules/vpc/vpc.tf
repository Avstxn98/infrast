module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "msk-ingress-vpc"
  cidr = "10.0.0.0/16"

  azs             = [var.azs.az1, var.azs.az2, var.azs.az3]
  private_subnets = ["${var.environment.network_prefix}.1.0/24", "1${var.environment.network_prefix}.2.0/24", "${var.environment.network_prefix}.3.0/24"]
  public_subnets  = ["${var.environment.network_prefix}.101.0/24", "${var.environment.network_prefix}.102.0/24", "${var.environment.network_prefix}.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "${var.environment.name}"
  }
}
