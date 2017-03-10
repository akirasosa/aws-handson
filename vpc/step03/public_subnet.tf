resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route_table" "internet" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"
  tags {
    Name = "Demo"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id = "${aws_subnet.public_a.id}"
  route_table_id = "${aws_route_table.internet.id}"
}
