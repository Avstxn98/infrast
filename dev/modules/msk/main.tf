module "msk" {
  source  = "terraform-aws-modules/msk-kafka-cluster/aws"
  version = "x.y.z"

  name                   = "example-msk"
  kafka_version          = "3.5.1"
  number_of_broker_nodes = 3

  broker_node_client_subnets = ["subnet-AAA", "subnet-BBB", "subnet-CCC"]
  broker_node_security_groups = [aws_security_group.msk_sg.id]

  encryption_in_transit_client_broker = "TLS"
  encryption_in_transit_in_cluster    = true
}