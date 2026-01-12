/**resource "aws_api_gateway_rest_api" "api" {
  name = "msk-api"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "any_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "proxy_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.any_method.http_method

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.nlb_link.id

  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"

  uri = "http://${module.aws_lb.nlb.dns_name}/{proxy}"
}

*/




resource "aws_apigatewayv2_api" "payment" {
  name          = var.api_vars.name
  protocol_type = var.api_vars.type
}

resource "aws_apigatewayv2_authorizer" "cognito_post" {
  api_id                            = aws_apigatewayv2_api.payment.id
  authorizer_type                   = var.api_authoriser.auth_type
  authorizer_uri                    = modules.auth.client.id
  identity_sources                  = var.api_authoriser.id_sources
  name                              = var.api_authoriser.name
  authorizer_payload_format_version = var.api_authoriser.format_version
}


resource "aws_apigatewayv2_integration" "payment_post" {
  api_id             = aws_apigatewayv2_api.payment.api_id
  credentials_arn    = aws_iam_role.example.arn
  description        = "Example with a load balancer"
  integration_type   = var.api_integration.integrated_type
  integration_uri    = var.api_integration.integration_uri
  integration_method = var.api_integration.integration_method
  connection_type    = "VPC_LINK"
  connection_id      = modules.vpc.vpc_id



  request_parameters = {
    "append:header.authforintegration" = "$context.authorizer.authorizerResponse"
    "overwrite:path"                   = "staticValueForIntegration"
  }
}
