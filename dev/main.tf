module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = var.ecs_config.cluster_name

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = var.ecs_config.cloud_watch_log_group_name
      }
    }
  }

  services = {
    payment_service = {
      cpu    = var.ecs_services.cpu
      memory = var.ecs_services.memory


      container_definitions = {
        fluent-bit = {
          cpu       = 512
          memory    = 1024
          essential = true
          image     = "906394416424.dkr.ecr.us-west-2.amazonaws.com/aws-for-fluent-bit:stable"
          firelensConfiguration = {
            type = "fluentbit"
          }
          memoryReservation = 50
        }

        ecs-sample = {
          cpu       = 512
          memory    = 1024
          essential = true
          image     = var.paymentserv_image
          portMappings = [
            {
              name          = "ecs-sample"
              containerPort = 80
              protocol      = "tcp"
            }
          ]
        }

      }


    }


  }



}
