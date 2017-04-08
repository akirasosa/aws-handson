# Live migrations from local to RDS.

Steps:

1. Create VPN server using OpenVPN.
2. Create RDS instance.
3. Dump local DB and copy it to remote server.
4. Import data into RDS.
5. Configure RDS instance to replicate from local DB.
6. Stop replication

References:

* [Importing Data to an Amazon RDS MySQL or MariaDB DB Instance with Reduced Downtime](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/MySQL.Procedural.Importing.NonRDSRepl.html)
* [OpenVPN: Amazon Web Services EC2 Community Appliance Quick Start Guide](https://docs.openvpn.net/how-to-tutorialsguides/virtual-platforms/amazon-ec2-appliance-ami-quick-start-guide/)

* [SlideShare](https://www.slideshare.net/asosa01/live-migration-from-onpremise-db-to-rds)

## Preparation

Initialize DB.

```bash
mysqladmin -uroot drop demo_db 
```

```sql
DROP USER 'demo'@'%';
```

Configure local MySQL to enable binary logging.

/etc/my.cnf 
```
[mysqld]
log-bin=mysql-bin
server-id=1
```

Restart MySQL.

```bash
 mysql.server restart # case for mysql installed by homebrew
```

## Create infrastructure

```bash
terraform plan
terraform apply
```

Note: It creates everything including OpenVPN servers and RDS.

## Configure OpenVPN

```bash
ssh -i demo.pem openvpnas@[public_ip]
sudo passwd openvpn
```

```bash
open https://[public_ip]:443
```

* Connect to OpenVPN server using OpenVPN client.

## Confirm ping for each others

```bash
# from local to VPN Server
ping 172.27.224.1
```

```bash
# from VPN Server to local
ping 172.27.232.2
```

## Try pinging from another ec2 instance to local

```bash
# another ec2
ping 172.27.232.2
```

It fails. It requires more config.

## Configure OpenVPN Server

```bash
open https://[public_ip]/admin:443
```

1. Check "VPN Settings - Dynamic IP Address Network - Network Address and mask".
2. Confirm that your route table uses this configuration.


1. Go to "User permissions - openvpn Show".
2. Enable "Allow Access From - all server-side private subnets".
3. Enable "Allow Access From - all other VPN clients".
4. Save settings and Update Running Server.

Try pinging again from ec2 instance to your local machine. It must be success.

## Mysql from ec2 server to local

Create a user in local MySQL DB.

```sql
CREATE USER 'demo'@'%' IDENTIFIED BY 'secret';
GRANT ALL PRIVILEGES ON *.* TO 'demo'@'%' WITH GRANT OPTION;
```

Install mysql client in ec2 and connect to local DB.

```bash
sudo yum install -y mysql
mysql -u demo -h 172.27.232.2 -p
```

## Dump local DB and copy it to remote server

Before dumping, populate some data.

```bash
mysqladmin -uroot create demo_db
mysql -uroot demo_db < demo_data.sql
```

Dump it.

```bash
mysqldump --databases demo_db --master-data=2 --single-transaction --order-by-primary -r dump.sql -u root
```

Memo log position, which will be used later.

```bash
grep MASTER_LOG_POS dump.sql
```

Copy it to ec2 instance.

```bash
gzip dump.sql
scp -i demo.pem dump.sql.gz ec2-user@10.0.1.224:/home/ec2-user
```

## Import data into RDS

```bash
gunzip dump.sql.gz
mysql -u demo_user -h [your hostname].ap-southeast-1.rds.amazonaws.com -p < dump.sql
```

## Configure RDS instance to replicate from local DB

Connect to RDS and configure replication.

```
mysql -u demo_user -h [your hostname].ap-southeast-1.rds.amazonaws.com -p
> CALL mysql.rds_set_external_master ('172.27.232.2', 3306, 'demo', 'secret', 'mysql-bin.000001', 3340, 0);
> CALL mysql.rds_start_replication;
> SHOW SLAVE STATUS
```

Add data in local.

```
mysql -uroot demo_db
> INSERT INTO animals (name) VALUES ('ga');
> INSERT INTO animals (name) VALUES ('heo');
```

Confirm that it was replicated to RDS.

```
> SELECT * FROM animals;
+----+------+
| id | name |
+----+------+
|  1 | meo  |
|  2 | cho  |
|  3 | ga   |
|  4 | heo  |
+----+------+
```

## Stop replication

At this point, you will update your app to switch DB. There would be a little downtime then.

1. Stop your app.
2. Update your app to use RDS.
3. Stop replication.
4. Start your app.

You can stop replication by following command.

```
> CALL mysql.rds_stop_replication;
> CALL mysql.rds_reset_external_master;
```

