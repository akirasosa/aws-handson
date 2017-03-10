resource "aws_instance" "web_a" {
  ami = "ami-4dc2712e"
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

