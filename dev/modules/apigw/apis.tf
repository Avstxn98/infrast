resource "aws_api_gateway_rest_api" "api" {
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

  uri = "http://${aws_lb.nlb.dns_name}/{proxy}"
}
