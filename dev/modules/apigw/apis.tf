module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name          = "payment-api-http"
  description   = "The API service to connect the backend payment processor to the frontend"
  protocol_type = "HTTPS"

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  # Custom domain
  domain_name = "terraform-aws-modules.modules.tf"

  # Access logs
  stage_access_log_settings = {
    create_log_group            = true
    log_group_retention_in_days = 7
    format = jsonencode({
      context = {
        domainName              = "$context.domainName"
        integrationErrorMessage = "$context.integrationErrorMessage"
        protocol                = "$context.protocol"
        requestId               = "$context.requestId"
        requestTime             = "$context.requestTime"
        responseLength          = "$context.responseLength"
        routeKey                = "$context.routeKey"
        stage                   = "$context.stage"
        status                  = "$context.status"
        error = {
          message      = "$context.error.message"
          responseType = "$context.error.responseType"
        }
        identity = {
          sourceIP = "$context.identity.sourceIp"
        }
        integration = {
          error             = "$context.integration.error"
          integrationStatus = "$context.integration.integrationStatus"
        }
      }
    })
  }

  # Authorizer(s)
  authorizers = {
    
  }

  # Routes & Integration(s)
  routes = {
    "POST /" = {
      integration = {
        uri                    = "arn:aws:lambda:eu-west-1:052235179155:function:my-function"
        payload_format_version = "2.0"
        timeout_milliseconds   = 12000
      }
    }

    "POST /pay" = {
        authorization_type = "AWS_COGNITO"
        authorizer_key = "${resource.client.authorizer_key}"

      integration = {
        type = "HTTP_PROXY"
        uri  = "${resource.payment.uri}"
      }
    }

    "GET /some-route-with-iam" = {
      authorization_type = "AWS_IAM"

      integration = {
        uri = "arn:aws:lambda:eu-west-1:052235179155:function:my-function"
      }
    }

    "$default" = {
      integration = {
        uri = "arn:aws:lambda:eu-west-1:052235179155:function:my-default-function"
      }
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}


resource "aws_apigatewayv2_integration" "example" {
  api_id           = aws_apigatewayv2_api.example.id
  credentials_arn  = aws_iam_role.example.arn
  description      = "Example with a load balancer"
  integration_type = "HTTP_PROXY"
  integration_uri  = aws_lb_listener.example.arn

  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.example.id

  tls_config {
    server_name_to_verify = "example.com"
  }

  request_parameters = {
    "append:header.authforintegration" = "$context.authorizer.authorizerResponse"
    "overwrite:path"                   = "staticValueForIntegration"
  }

  response_parameters {
    status_code = 403
    mappings = {
      "append:header.auth" = "$context.authorizer.authorizerResponse"
    }
  }

  response_parameters {
    status_code = 200
    mappings = {
      "overwrite:statuscode" = "204"
    }
  }
} 