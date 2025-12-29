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


resource "aws_lb" "nlb" {
  name               = "msk-proxy-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = [for subnet in module.vpc.private_subnets : subnet.id]
}

resource "aws_lb_target_group" "proxy_tg" {
  name        = "msk-proxy-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.proxy_tg.arn
  }
}
