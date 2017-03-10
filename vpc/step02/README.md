# Step 2

Create a private subnet and access to it through ELB in public subnet.

Estimated time is 30 min.

## Create an ELB

* Create an ELB.
* Plan and Apply.
* Show ELB DNS name as output.

## Update security group for the ELB

* Create a sg for internal http traffic.
* Confirm that ELB can show web page.
* Remove unused sg usage of web instance.
* Confirm that web instance does not show web page from direct access.

## Create a private subnet.

* Create a private subnet.

## Move web instance to the private subnet.

* Update web instance to use the private subnet.
* Update web instance to use ami created before.
* Confirm that web page is available still.

## Create a bastion and try security update.

* Create a bastion instance with internal sg.
* SSH to the instance in private through the bastion.
* Confirm that ```yum update``` is *unavailable*.

```bash
ssh-add -K demo.pem
ssh -A ec2-user@bastion_ip
ssh ec2-user@private_ip
```