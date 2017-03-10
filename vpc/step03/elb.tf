resource "aws_elb" "main" {
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  subnets = [
    "${aws_subnet.public_a.id}",
  ]
  instances = [
    "${aws_instance.web_a.id}",
  ]
  security_groups = [
    "${aws_security_group.internet_web.id}",
    "${aws_security_group.internal.id}",
  ]
}
