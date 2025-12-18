data "aws_msk_bootstrap_brokers" "msk" {
  cluster_arn = aws_msk_serverless_cluster.main.arn
}

output "msk_bootstrap_brokers" {
  value = data.aws_msk_bootstrap_brokers.msk.bootstrap_brokers_sasl_iam
}
