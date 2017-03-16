resource "aws_instance" "web_a" {
  ami = "ami-fc1f439b"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.private_a.id}"
  key_name = "demo"
  vpc_security_group_ids = [
    "${aws_security_group.internal.id}",
  ]
  tags {
    Name = "Demo"
  }
}

resource "aws_instance" "web_b" {
  ami = "ami-fc1f439b"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.private_b.id}"
  key_name = "demo"
  vpc_security_group_ids = [
    "${aws_security_group.internal.id}",
  ]
  tags {
    Name = "Demo"
  }
}

