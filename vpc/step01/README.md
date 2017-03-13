# Step 1

Create a single subnet in VPC and create a web server in it.

Estimated time is 20 min.

## Create a VPC

* Create a VPC by using given CIDR.
* Plan.
* Apply.
* Confirm that the default Route Table was created.
* Destroy.
* Apply.
  
## Create a subnet

* Plan and Apply.
* Confirm that the subnet is associated with default Route Table.
  
## Create an instance

* Plan and Apply.
* Confirm that the instance belongs to default Security Group (sg).

Instance is automatically assigned to default sg.
  
## Security Group

* Create sg for Http.
* Update instance to use the http sg.
* Need to install web server.
* Create sg for SSH.
* Update instance to use the ssh sg.
* Update instance to use demo key.
* Update instance to have a public IP.

## Access to the web server

* SSH to the instance.
* Confirm that it's *not* accessible.
  
```bash
ssh -i demo.pem ec2-user@instance_ip
```

## Internet Gateway

* Create an Internet Gateway.
* Register it to Route Table.
* Associate it with the subnet created.
* Plan and Apply.
* Confirm that it's accessible by ssh.
  
## Install Web Server

* Try to install nginx and fails.
* Update sg to allow outgoing traffic.
* Plan and apply.
* Try to install again.
* Start nginx.
* Confirm that web page is shown.
  
```hcl-terraform
egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
```

```bash
sudo yum update -y
sudo yum install -y nginx
sudo service nginx start
```

## Create an AMI to use it later

We don't want to install nginx again, when we will create other servers.

* Enable run on boot.
* Create an AMI.
  
```bash
sudo chkconfig nginx on
sudo chkconfig --list nginx
```

## References

* [aws_vpc](https://www.terraform.io/docs/providers/aws/r/vpc.html)
* [aws_subnet](https://www.terraform.io/docs/providers/aws/r/subnet.html)
* [aws_internet_gateway](https://www.terraform.io/docs/providers/aws/r/internet_gateway.html)
* [aws_route_table](https://www.terraform.io/docs/providers/aws/r/route_table.html)
* [aws_route_table_association](https://www.terraform.io/docs/providers/aws/r/route_table_association.html)
* [aws_instance](https://www.terraform.io/docs/providers/aws/r/instance.html)
