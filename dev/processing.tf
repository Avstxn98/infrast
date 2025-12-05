module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.environment.name
  cidr = "${var.environment.network_prefix}.0.0/16"

  azs            = ["eu-west-2a", "us-west-2b", "us-west-2c"]
  public_subnets = ["${var.environment.network_prefix}.101.0/24", "${var.environment.network_prefix}.102.0/24", "${var.environment.network_prefix}.103.0/24"]


  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "${var.environment.name}"
  }
}

module "ecs_cluster" {
  source = "terraform-aws-modules/ecs/aws//modules/cluster"

  name = "ecs-fargate"

  configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
      }
    }
  }

  default_capacity_provider_strategy = {
    FARGATE = {
      weight = 50
      base   = 20
    }
    FARGATE_SPOT = {
      weight = 50
    }
  }

  tags = {
    Environment = "${var.environment.name}"

  }
}

module "ecs_container_definition" {
  source = "terraform-aws-modules/ecs/aws//modules/container-definition"

  name      = "example"
  cpu       = 512
  memory    = 1024
  essential = true
  image     = "public.ecr.aws/aws-containers/ecsdemo-frontend:776fd50"
  portMappings = [
    {
      name          = "ecs-sample"
      containerPort = 80
      protocol      = "tcp"
    }
  ]

  # Example image used requires access to write to root filesystem
  readonlyRootFilesystem = false

  memoryReservation = 100

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
