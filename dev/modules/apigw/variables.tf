variable "api_vars" {

  description = "vars for the api definition"
  type = object({
    name = string
    type = string

  })
  default = {
    name = "payment-http-api"
    type = "HTTP"
  }


}

variable "api_authoriser" {
  description = "vars for the authoriser"
  type = object({
    name           = string
    auth_type      = string
    auth_uri       = string
    id_sources     = list()
    format_version = string
  })
  default = {
    auth_type      = "REQUEST"
    auth_uri       = "${modules.auth.client.id}"
    id_sources     = ["$request.header.Authorization"]
    format_version = "2.0"
  }
}



variable "api_integration" {
  description = "vars for the integration"
  type = object({
    integration_uri    = string
    integration_method = string
    integrated_type    = string

  })
  default = {
    integration_uri    = "http://${module.aws_lb.nlb.dns_name}/{proxy}"
    integration_method = "POST"
    integrated_type    = "HTTP_PROXY"
  }

}
