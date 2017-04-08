resource "aws_db_instance" "main" {
  allocated_storage = 5
  engine = "mysql"
  engine_version = "5.7.10"
  instance_class = "db.t2.micro"
  vpc_security_group_ids = [
    "${aws_security_group.internal.id}",
  ]
  db_subnet_group_name = "${aws_db_subnet_group.main.name}"
  username = "demo_user"
  password = "${var.db_password}"
}

resource "aws_db_subnet_group" "main" {
  name = "demo"
  description = "demo"
  subnet_ids = [
    "${aws_subnet.public_a.id}",
    "${aws_subnet.public_b.id}",
  ]
}