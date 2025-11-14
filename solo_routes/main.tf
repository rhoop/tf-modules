data "terraform_remote_state" "leaf_vpc" {
  backend = "s3"

  config {
    bucket = "${var.s3_bucket_prefix}-terraform-state"
    key    = "vpc/${var.env}/main.tfstate"
    region = "us-west-2"
  }
}

# Routing table for vpn subnets
resource "aws_route_table" "vpn" {
  vpc_id = data.terraform_remote_state.leaf_vpc.vpc.id

  tags = {
    Name = "${var.env}_vpn"
  }
}

resource "aws_route" "vpn_egress" {
  route_table_id         = aws_route_table.vpn.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = data.terraform_remote_state.leaf_vpc.vpc.igw
}

resource "aws_route_table_association" "vpn-1a" {
  subnet_id      = data.terraform_remote_state.leaf_vpc.subnet_vpn.a.id
  route_table_id = aws_route_table.vpn.id
}

resource "aws_route_table_association" "vpn-1b" {
  subnet_id      = data.terraform_remote_state.leaf_vpc.subnet_vpn.b.id
  route_table_id = aws_route_table.vpn.id
}

resource "aws_route_table_association" "vpn-1d" {
  subnet_id      = data.terraform_remote_state.leaf_vpc.subnet_vpn.d.id
  route_table_id = aws_route_table.vpn.id
}

# Routing table for public subnets
resource "aws_route_table" "public" {
  vpc_id = data.terraform_remote_state.leaf_vpc.vpc.id

  tags = {
    Name = "${var.env}_public"
  }
}

resource "aws_route" "public_egress" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = data.terraform_remote_state.leaf_vpc.vpc.igw
}

resource "aws_route_table_association" "public-1a" {
  subnet_id      = data.terraform_remote_state.leaf_vpc.subnet_public.a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-1b" {
  subnet_id      = data.terraform_remote_state.leaf_vpc.subnet_public.b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-1d" {
  subnet_id      = data.terraform_remote_state.leaf_vpc.subnet_public.d.id
  route_table_id = aws_route_table.public.id
}

# Routing table for private subnets
resource "aws_route_table" "private" {
  vpc_id = data.terraform_remote_state.leaf_vpc.vpc.id

  tags = {
    Name = "${var.env}_private"
  }
}

resource "aws_route" "private_egress" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = data.terraform_remote_state.leaf_vpc.vpc.nat
}

resource "aws_route_table_association" "private-1a" {
  subnet_id      = data.terraform_remote_state.leaf_vpc.subnet_private.a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-1b" {
  subnet_id      = data.terraform_remote_state.leaf_vpc.subnet_private.b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-1d" {
  subnet_id      = data.terraform_remote_state.leaf_vpc.subnet_private.d.id
  route_table_id = aws_route_table.private.id
}

# Routing table for protected subnets
resource "aws_route_table" "protected" {
  vpc_id = data.terraform_remote_state.leaf_vpc.vpc.id

  tags = {
    Name = "${var.env}_protected"
  }
}

resource "aws_route_table_association" "protected-1a" {
  subnet_id      = data.terraform_remote_state.leaf_vpc.subnet_protected.a.id
  route_table_id = aws_route_table.protected.id
}

resource "aws_route_table_association" "protected-1b" {
  subnet_id      = data.terraform_remote_state.leaf_vpc.subnet_protected.b.id
  route_table_id = aws_route_table.protected.id
}

resource "aws_route_table_association" "protected-1d" {
  subnet_id      = data.terraform_remote_state.leaf_vpc.subnet_protected.d.id
  route_table_id = aws_route_table.protected.id
}
