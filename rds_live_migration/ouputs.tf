output "vpn_instance_ip" {
  value = "${aws_eip.vpn.public_ip}"
}

output "tmp_instance_ip" {
  value = "${aws_instance.tmp.private_ip}"
}

output "rds_endpoint" {
  value = "${aws_db_instance.main.endpoint}"
}
