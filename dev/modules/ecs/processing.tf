/*
module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = "ecs-integrated"

  cluster_configuration = {
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
  } }
  services = {

    payment_cluster = {

      cpu    = 1
      memory = 1

      container_definitions = {
        {module.ecs_container_definition.name}





      }


    }


  }

  tags = {
    Environment = "${var.environment.name}"

  }
}

"module "ecs_container_definition" {
  source = "terraform-aws-modules/ecs/aws//modules/container-definition"

  name      = "payment-processor"
  cpu       = 512
  memory    = 1024
  essential = true
  image     = "public.ecr.aws/aws-containers/ecsdemo-frontend:776fd50"
  portMappings = [
    {
      name          = "payment-processor"
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
  }"
}

*/


resource "aws_ecr_repository" "processing_repo_stage1" {
  name = var.repo_name.processor1


  tags = {
    Name = "${var.environment.name}"
  }
}

resource "aws_ecr_repository" "processing_repo_stage1" {
  name = var.repo_name.processor1


  tags = {
    Name = "${var.environment.name}"
  }
}


resource "aws_ecs_task_definition" "my_first_task" {
  family                   = "processing-tasks"
  container_definitions    = <<DEFINITION
[
  {
    "name": "task-stage1",
    "image": "${aws_ecr_repository.processing_repo_stage1.repository_url}",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],environment = [
        {
          name  = "KAFKA_BOOTSTRAP_SERVERS"
          value = module.msk.bootstrap_brokers_tls
        }
      ],
    "memory": 512,
    "cpu": 256,
    "networkMode": "awsvpc"
  },{
  "name": "task-stage2",
    "image": "${aws_ecr_repository.my_first_ecr_repo.repository_url}",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],environment = [
        {
          name  = "KAFKA_BOOTSTRAP_SERVERS"
          value = module.msk.bootstrap_brokers_tls
        }
      ],
    "memory": 512,
    "cpu": 256,
    "networkMode": "awsvpc"
  }
]
  DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  cpu                      = 256
}


resource "aws_ecs_cluster" "my_cluster" {
  name = "my-ecs-cluster"
}



resource "aws_ecs_service" "my_first_services" {
  name                = "gft-test-first-services"
  cluster             = aws_ecs_cluster.my_cluster.id
  task_definition     = my_first_task.arn
  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"
  desired_count       = 1

  network_configuration {
    subnets          = [aws_default_subnet.ecs_az1.id]
    assign_public_ip = false
  }
}
