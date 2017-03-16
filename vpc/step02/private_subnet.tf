resource "aws_subnet" "private_a" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-northeast-1a"
  tags {
    Name = "Demo"
  }
}

