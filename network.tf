resource "aws_vpc" "redpanda" {
  count                = var.create_cluster ? 1 : 0
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.vpc_dns_support
  enable_dns_hostnames = var.vpc_dns_hostnames
}

resource "aws_subnet" "public" {
  count                = var.create_cluster ? length(var.public_subnet_cidrs) : 0
  vpc_id               = aws_vpc.redpanda[count.index].id
  availability_zone_id = element(var.zones, count.index)
  cidr_block           = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true

  tags = merge({
    # Hints k8s where it can provision public network load balancers.
    "kubernetes.io/role/elb" = 1,
    # We add this tag to enable discovering the subnet from Terraform code
    # that provisions Redpanda clusters, as another alternative.
    "redpanda.subnet.public" = 1,
  }, data.aws_default_tags.current[count.index].tags)
}

resource "aws_subnet" "private" {
  count                   = var.create_cluster ? length(var.private_subnet_cidrs) : 0
  vpc_id                  = aws_vpc.redpanda[count.index].id
  availability_zone_id    = element(var.zones, count.index)
  cidr_block              = var.private_subnet_cidrs[count.index]
  map_public_ip_on_launch = false
  tags = merge({
    # Hints k8s where it can provision private network load balancers.
    "kubernetes.io/role/internal-elb" = 1,
    # We add this tag to enable discovering the subnet from Terraform code
    # that provisions Redpanda clusters, as another alternative.
    "redpanda.subnet.private" = 1,
  }, data.aws_default_tags.current[count.index].tags)
}

# Creates a private gateway vpc endpoint for S3 traffic. So traffic to S3
# doesn't go through the NAT gateway, which is more expensive.
resource "aws_vpc_endpoint" "s3" {
  count             = var.create_cluster ? 1 : 0
  vpc_id            = aws_vpc.redpanda[count.index].id
  service_name      = data.aws_vpc_endpoint_service.s3[count.index].service_name
  vpc_endpoint_type = data.aws_vpc_endpoint_service.s3[count.index].service_type
}

# Ensures that the default security group created by the VPC
# is properly tagged with the default provider tags.
# Terraform does not create this default SG but instead attempts
# to "adopt" it into management. On adoption it immediately removes
# all ingress and egress rules in the security group and recreates
# it with the rules specified here. Check the doc for more details.
resource "aws_default_security_group" "redpanda" {
  count  = var.create_cluster ? 1 : 0
  vpc_id = aws_vpc.redpanda[count.index].id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Each NAT Gateway needs an Elastic IP Address that is used as source IP
// when forwarding traffic to the internet gateway.
resource "aws_eip" "nat_gateway" {
  count  = var.create_cluster ? 1 : 0
  vpc    = true
}

resource "aws_internet_gateway" "redpanda" {
  count  = var.create_cluster ? 1 : 0
  vpc_id = aws_vpc.redpanda[count.index].id
}

// We place a NAT gateway in the public network of each availability zone,
// for the AZs private networks to use.
// We don't create a NAT gateway for the unused AZs (single-AZ scenario)
resource "aws_nat_gateway" "redpanda" {
  count         = var.create_cluster ? 1 : 0
  allocation_id = aws_eip.nat_gateway[count.index].id
  subnet_id     = aws_subnet.public[0].id

  depends_on = [
    aws_internet_gateway.redpanda,
  ]
}

// Allows private subnets to reach their AZ local NAT gateway for outgoing internet
// traffic.
resource "aws_route" "nat" {
  count                  = var.create_cluster ? length(aws_route_table.private) : 0
  route_table_id         = aws_route_table.private.*.id[count.index]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.redpanda[count.index].id
}

// Routes public subnets outbound internet traffic through the VPC internet gateway.
resource "aws_route" "public" {
  count                  = var.create_cluster ? 1 : 0
  route_table_id         = aws_route_table.main[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.redpanda[count.index].id
}
