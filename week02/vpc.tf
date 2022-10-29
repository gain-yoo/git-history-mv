provider "aws" {
  region  = "ap-northeast-2"
}

resource "aws_vpc" "yoogavpc" {
  cidr_block       = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "t101-study"
  }
}

resource "aws_subnet" "yoogasubnet1" {
  vpc_id     = aws_vpc.yoogavpc.id
  cidr_block = "10.10.1.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "t101-subnet1"
  }
}

resource "aws_subnet" "yoogasubnet2" {
  vpc_id     = aws_vpc.yoogavpc.id
  cidr_block = "10.10.2.0/24"

  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "t101-subnet2"
  }
}


resource "aws_internet_gateway" "yoogaigw" {
  vpc_id = aws_vpc.yoogavpc.id

  tags = {
    Name = "t101-igw"
  }
}

resource "aws_route_table" "yoogart" {
  vpc_id = aws_vpc.yoogavpc.id

  tags = {
    Name = "t101-rt"
  }
}

resource "aws_route_table_association" "yoogartassociation1" {
  subnet_id      = aws_subnet.yoogasubnet1.id
  route_table_id = aws_route_table.yoogart.id
}

resource "aws_route_table_association" "yoogartassociation2" {
  subnet_id      = aws_subnet.yoogasubnet2.id
  route_table_id = aws_route_table.yoogart.id
}

resource "aws_route" "yoogadefaultroute" {
  route_table_id         = aws_route_table.yoogart.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.yoogaigw.id
}

