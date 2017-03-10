resource "aws_nat_gateway" "main" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.public_a.id}"
}

resource "aws_eip" "nat" {
}

resource "aws_route_table" "nat" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.main.id}"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-southeast-1a"
  tags {
    Name = "Demo"
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id = "${aws_subnet.private_a.id}"
  route_table_id = "${aws_route_table.nat.id}"
}
