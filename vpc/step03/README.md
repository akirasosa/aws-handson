# Step 3

Create a NAT Gateway and use it for patch updating instances in private subnet.

Estimated time is 15 min.

## Create a NAT Gateway

* Create an NAT Gateway with EIP.
* Register it to Route Table.
* Associate it with private subnet.
* Add security group for patch update.
* Plan and Apply.
* Confirm that ```yum update``` is available from private subnet.
