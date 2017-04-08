resource "aws_instance" "vpn" {
  // openvpn ami
  ami = "ami-a859ffcb"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = "demo"
  source_dest_check = false
  subnet_id = "${aws_subnet.public_a.id}"
  user_data = "${file("./user_data.sh")}"
  vpc_security_group_ids = [
    "${aws_security_group.internet_vpn.id}",
    "${aws_security_group.internal.id}",
  ]
}

resource "aws_eip" "vpn" {
  instance = "${aws_instance.vpn.id}"
  vpc = true
}