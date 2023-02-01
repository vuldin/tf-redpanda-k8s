/*
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}
*/

# TODO remove once we are creating the EKS cluster
resource "local_file" "eks_config" {
  count    = var.create_cluster ? 1 : 0
  filename = "eks-config.yaml"
  content              = templatefile("${path.module}/templates/eks-config.yaml.tpl", {
    cluster_name       = var.cluster_name
    region             = var.region
    vpc_id             = aws_vpc.redpanda[count.index].id
    public_subnet_azs  = tolist(aws_subnet.public.*.availability_zone)
    public_subnet_ids  = tolist(aws_subnet.public.*.id)
    private_subnet_azs = tolist(aws_subnet.private.*.availability_zone)
    private_subnet_ids = tolist(aws_subnet.private.*.id)
  })
}

# TODO remove once helm chart allows loadBalancer
resource "local_file" "lb_config" {
  count    = var.generate_load_balancer_config ? 1 : 0
  filename = "lb-config.yaml"
  content  = templatefile("${path.module}/templates/lb-config.yaml.tpl", {
    cluster_name                = var.cluster_name
    load_balancer_source_ranges = var.load_balancer_source_ranges
    public_subnet_azs           = tolist(aws_subnet.public.*.availability_zone)
  })
}
