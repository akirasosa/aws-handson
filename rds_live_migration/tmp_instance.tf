resource "aws_instance" "tmp" {
  // aws ami
  ami = "ami-dc9339bf"
  instance_type = "t2.micro"
  key_name = "demo"
  associate_public_ip_address = true
  subnet_id = "${aws_subnet.public_a.id}"
  vpc_security_group_ids = [
    "${aws_security_group.internal.id}",
  ]
}
