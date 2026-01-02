variable "azs" {
  description = "Deployment environment"

  type = object({
    az1 = string
    az2 = string
    az3 = list()
  })
  default = {
    az1 = "eu-west-1a"
    az2 = "eu-west-1b"
    az3 = "eu-west-1c"
  }


}


variable "environment" {
  description = "Deployment environment"

  type = object({
    name           = string
    network_prefix = string

  })
  default = {
    name           = "dev"
    network_prefix = "10.0"
  }


}
