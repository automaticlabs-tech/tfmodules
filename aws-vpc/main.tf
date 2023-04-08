resource "aws_vpc" "this" {

  cidr_block             = var.cidr_block
  instance_tenancy       = "default"
  enable_dns_hostnames   = var.enable_dns_hostnames
  enable_dns_support     = var.enable_dns_support 

tags = "${merge
         (var.vpc_tags)
    }"
 }

resource "aws_subnet" "private" {
  count = var.enable_private_subnet ? 1 : 0
  vpc_id             = aws_vpc.this.id
  availability_zone  = var.default_az
  cidr_block = "172.16.1.0/24"

    tags = "${merge
            (var.private_subnet_tags)
        }"
}

resource "aws_route_table" "private" {
  count = var.enable_private_subnet ? 1 : 0
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.this[count.index].id

  }

  tags = {
    Name = "private"
    Tier = "poc"
  }
}

resource "aws_eip" "this" {
  count = var.enable_private_subnet ? 1 : 0    
  vpc      = true
}

resource "aws_nat_gateway" "this" {
  count = var.enable_private_subnet ? 1 : 0
  allocation_id = aws_eip.this[count.index].id
  subnet_id     = aws_subnet.private[count.index].id

  tags = {
    Name = "NAT GW"
  }
}

resource "aws_route_table_association" "private" {
  count = var.enable_private_subnet ? 1 : 0
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_subnet" "public" {
  count = var.enable_public_subnet ? 1 : 0  
  vpc_id = aws_vpc.this.id
  availability_zone  = var.default_az
  cidr_block = "172.16.2.0/24"

    tags = "${merge
            (var.public_subnet_tags)
        }"
}

output "public_subnet_id" {
  value = one(aws_subnet.public[*].id)
}

resource "aws_internet_gateway" "this" {
  count = var.enable_public_subnet ? 1 : 0 
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "DefaultGW"
    Tier = "Poc"
  }
}

resource "aws_route_table" "public" {
  count = var.enable_public_subnet ? 1 : 0
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[count.index].id

  }
}

resource "aws_route_table_association" "public" {
  count = var.enable_public_subnet ? 1 : 0
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

