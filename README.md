# Node infrastructure

## Setup

1. create a config file `cp config.env.dist config.env`
2. change your config
3. update your `hosts.ini` in your `/ansible` directory
4. run `make new-node`

## Replacements

* REPLACE_ME_WITH_YOUR_HOSTNAME -> replace with your VPN host such as `vpn.domain.com` **(openVPN is at the moment not active)**

## Debugging

### SQL script for MySQL cluster

> `mysql -h 127.0.0.1 -P 3306 -u root -p` enter your root password

```sql
-- Ensure we start fresh by dropping any existing users and databases
DROP DATABASE IF EXISTS shlink;
DROP DATABASE IF EXISTS invoiceplane;
DROP USER IF EXISTS 'shlink'@'%';
DROP USER IF EXISTS 'invoiceplane'@'%';

-- Create databases
CREATE DATABASE shlink;
CREATE DATABASE invoiceplane;

-- Create users with passwords
CREATE USER 'shlink'@'%' IDENTIFIED BY 'your_shlink_password';
CREATE USER 'invoiceplane'@'%' IDENTIFIED BY 'your_invoiceplane_password';

-- Grant privileges to the users on their respective databases
GRANT ALL PRIVILEGES ON shlink.* TO 'shlink'@'%';
GRANT ALL PRIVILEGES ON invoiceplane.* TO 'invoiceplane'@'%';

-- Flush privileges to apply changes
FLUSH PRIVILEGES;
```

> test your new created user with:
> `mysql -h 127.0.0.1 -P 3306 -D invoiceplane -u invoiceplane -p` enter your password: `your_invoiceplane_db_password`
> `mysql -h 127.0.0.1 -P 3306 -D shlink -u shlink -p` enter your password: `your_shlink_db_password`
