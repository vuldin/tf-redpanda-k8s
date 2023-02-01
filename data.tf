data "aws_vpc_endpoint_service" "s3" {
  count        = var.create_cluster ? 1 : 0
  service      = "s3"
  service_type = "Gateway"
}

data "aws_default_tags" "current" {
  count        = var.create_cluster ? 1 : 0
}
