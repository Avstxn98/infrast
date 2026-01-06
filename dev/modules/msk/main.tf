resource "aws_msk_serverless_cluster" "msk_serverless" {
  cluster_name = "payment-msk-serverless"

  client_authentication {
    sasl {
      iam {
        enabled = true
      }
    }
  }

  vpc_config {
    subnet_ids = module.vpc.private_subnets

  }
}

