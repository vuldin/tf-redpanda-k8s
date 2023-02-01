// The main route table routes our outgoing internet traffic through
// the internet gateway.
resource "aws_route_table" "main" {
  count  = var.create_cluster ? 1 : 0
  vpc_id = aws_vpc.redpanda[count.index].id
}

// We need to create a routing table per each private subnet in order to
// properly route outgoing internet traffic to each private subnet's NAT gateway.
// This is needed because we can't specify an origin network when creating routing
// rules in AWS.
resource "aws_route_table" "private" {
  count  = var.create_cluster ? length(var.private_subnet_cidrs) : 0
  vpc_id = aws_vpc.redpanda[count.index].id

  tags = {
    purpose = "private"
  }
}

// Associates VPC to main routing table.
resource "aws_main_route_table_association" "vpc-main-route-table" {
  count          = var.create_cluster ? 1 : 0
  vpc_id         = aws_vpc.redpanda[count.index].id
  route_table_id = aws_route_table.main[count.index].id
}

// Associates public subnets to main routing table.
resource "aws_route_table_association" "public" {
  count          = var.create_cluster ? length(var.public_subnet_cidrs) : 0
  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.main[count.index].id
}

// Associates private subnets to private routing tables. Remember, there is a
// private and public subnet per AZ, and a NAT gateway has to be created per
// each public subnet in order to have high availability. So, here, we are
// basically associating each private routing table to each private subnet.
// A routing table per private subnet is required in order to foward outgoing
// internet traffic from private subnets to their correspondent NAT gateway,
// since we can't specify the origin network in AWS routing rules.
resource "aws_route_table_association" "private" {
  count          = var.create_cluster ? length(var.private_subnet_cidrs) : 0
  subnet_id      = aws_subnet.private.*.id[count.index]
  route_table_id = aws_route_table.private.*.id[count.index]
}
