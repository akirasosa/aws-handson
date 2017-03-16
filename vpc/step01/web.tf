resource "aws_instance" "web_a" {
  ami = "ami-56d4ad31"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public_a.id}"
  associate_public_ip_address = true
  key_name = "demo"
  vpc_security_group_ids = [
    "${aws_security_group.internet_ssh.id}",
    "${aws_security_group.internet_web.id}",
  ]
  tags {
    Name = "Demo"
  }
}

