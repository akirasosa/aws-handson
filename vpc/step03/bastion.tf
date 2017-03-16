resource "aws_instance" "bastion" {
  ami = "ami-56d4ad31"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public_a.id}"
  key_name = "demo"
  associate_public_ip_address = true
  vpc_security_group_ids = [
    "${aws_security_group.internet_ssh.id}",
    "${aws_security_group.internal.id}",
  ]
  tags {
    Name = "Demo"
  }
}

