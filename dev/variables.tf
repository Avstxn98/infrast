variable "ecs_config" {
  description = "ECS variables to change"

  type = object({
    cluster_name   = string
    fargate_weight = string
  })
  default = {
    name           = "dev"
    network_prefix = "10.0"
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
variable "ecs_image" {

}
