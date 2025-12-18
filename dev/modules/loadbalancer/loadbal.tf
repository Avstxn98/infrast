resource "aws_lb" "payment" {
  name               = "payment-lb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [for subnet in module.vpc.private_subnets : subnet.id]

  enable_deletion_protection = true

  tags = {
    Environment = "${var.environment.name}"
  }
}