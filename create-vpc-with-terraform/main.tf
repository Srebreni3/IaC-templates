resource "aws_vpc" "ahmed_srebrenica_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "ahmed-srebrenica-vpc"
  }
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id     = aws_vpc.ahmed_srebrenica_vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "public-subnet-a"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id     = aws_vpc.ahmed_srebrenica_vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "public-subnet-b"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ahmed_srebrenica_vpc.id
  tags = {
    Name = "igw-ahmed-srebrenica"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.ahmed_srebrenica_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_subnet_a_association" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_b_association" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id     = aws_vpc.ahmed_srebrenica_vpc.id
  cidr_block = "10.0.3.0/24"
  tags = {
    Name = "private-subnet-a"
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id     = aws_vpc.ahmed_srebrenica_vpc.id
  cidr_block = "10.0.4.0/24"
  tags = {
    Name = "private-subnet-b"
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_a.id
  tags = {
    Name = "nat-gw-ahmed-srebrenica"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.ahmed_srebrenica_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "private_subnet_a_association" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_b_association" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_route_table.id
}