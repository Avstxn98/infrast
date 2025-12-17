variable "ecs_config" {
  description = "ECS variables to change"

  type = object({
    cluster_name               = string
    cloud_watch_log_group_name = string
    fargate_weight             = string
  })
  default = {
    cluster_name               = "dev"
    cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
  }
}



variable "ecs_services" {
  type = object({
    cpu       = number
    memory    = number
    essential = bool


  })
  default = {
    cpu       = 512
    memory    = 1024
    essential = true

  }

}
variable "portMappings" {
  type = object({

    containerport = number
    protocol      = string


  })

  default = {
    containerport = 80
    protocol      = "tcp"
  }




}
variable "paymentserv_image" {
  default = ""


}

variable "environment" {
  description = "Deployment environment"

  type = object({
    name           = string
    network_prefix = string
    availzones     = list()
  })
  default = {
    name           = "dev"
    network_prefix = "10.0"
  }


}
variable "repo_name" {
  type = object({
    processor1 = string
    processor2 = string
    processor3 = string
  })
  default = {
    processor1 = "processing-repo-stage1"
    processor2 = "processing-repo-stage2"
    processor3 = "processing-repo-stage3"
  }

}
