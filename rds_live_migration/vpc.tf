resource aws_vpc "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }
  route {
    // maybe configure it later
    cidr_block = "172.27.224.0/20"
    instance_id = "${aws_instance.vpn.id}"
  }
}

resource "aws_route_table" "vpn" {
  vpc_id = "${aws_vpc.main.id}"
}

// ------------ public a ------------

resource "aws_subnet" "public_a" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"
}

resource "aws_route_table_association" "public_a" {
  subnet_id = "${aws_subnet.public_a.id}"
  route_table_id = "${aws_route_table.main.id}"
}

// ------------ public b ------------

resource "aws_subnet" "public_b" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-southeast-1b"
}

resource "aws_route_table_association" "public_b" {
  subnet_id = "${aws_subnet.public_b.id}"
  route_table_id = "${aws_route_table.main.id}"
}

