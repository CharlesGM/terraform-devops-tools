# Resource: aws_subnet
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "private-us-east-1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_prefix[0]
  availability_zone = "us-east-1a"

  tags = {
    "Name"                              = "private-us-east-1a"
    "kubernetes.io/role/internal-elb"   = "1"
    "kubernetes.io/cluster/ledgerndary" = "owned"
  }
}

resource "aws_subnet" "private-us-east-1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_prefix[1]
  availability_zone = "us-east-1b"

  tags = {
    "Name"                              = "private-us-east-1b"
    "kubernetes.io/role/internal-elb"   = "1"
    "kubernetes.io/cluster/ledgerndary" = "owned"
  }
}

resource "aws_subnet" "public-us-east-1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_prefix[2]
  availability_zone = "us-east-1a"

  tags = {
    "Name"                              = "public-us-east-1a"
    "kubernetes.io/role/elb"            = "1"
    "kubernetes.io/cluster/ledgerndary" = "owned"
  }
}

resource "aws_subnet" "public-us-east-1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_prefix[3]
  availability_zone = "us-east-1b"

  tags = {
    "Name"                              = "public-us-east-1b"
    "kubernetes.io/role/elb"            = "1"
    "kubernetes.io/cluster/ledgerndary" = "owned"
  }
}
