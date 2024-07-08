# Node infrastructure

## Setup

1. create a config file `cp config.env.dist config.env`
2. change your config
3. update your `hosts.ini` in your `/ansible` directory
4. run `make new-node`

### Access via SSH

Many VPS providers support a direct SSH integration. That means you can create a SSH-Key pair during setup. However some providers you have to set it up manually.

1. Generate key pair: `ssh-keygen -t rsa` set a passphrase
2. Copy key to remove VM: `ssh-copy-id -o IdentitiesOnly=yes -i ~/.ssh/id_rsa.pub ubuntu@192.168.0.85`

### Contabo

Contabo uses as the default user the `root` user. So we want to create a non-root user at first and deactivate the root user afterwards.

```bash
#!/bin/bash

# Update the package list and upgrade the system packages
apt update && apt upgrade -y

# Create a new user called 'ubuntu'
adduser --disabled-password --gecos "" ubuntu

# Set a password for the 'ubuntu' user (you can change 'yourpassword' to a desired password)
echo "ubuntu:yourpassword" | chpasswd

# Add 'ubuntu' user to the necessary groups (sudo, adm, etc.)
usermod -aG sudo,adm,dialout,cdrom,floppy,audio,dip,video,plugdev ubuntu

# Copy the default .bashrc and .profile from /etc/skel to the new user's home directory
cp /etc/skel/.bashrc /home/ubuntu/
cp /etc/skel/.profile /home/ubuntu/

# Set the correct ownership for the home directory
chown -R ubuntu:ubuntu /home/ubuntu/

# Deactivate the root user by locking the account
passwd -l root

# Optionally, disable root login via SSH
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart sshd

echo "User 'ubuntu' created and root user deactivated."
```

After you have created your `ubuntu` user, you can do "[Access via SSH](#access-via-ssh)" again for the `ubuntu` user.

> IMPORTANT: Notice that you must start your ansible playbook with `make new-node-sudo` owing to the reason you need a way to pass the BECOME (sudo) password. [Source: Missing sudo password in Ansible](https://stackoverflow.com/a/51864689/13100186)

> IMPORTANT: Contabo has problems to restart the VM, so comment out this this task `Reboot machine` in this file `/ansible/roles/initialisation/tasks/main.yaml`. But restart the VM as soon as the Ansible script is finished.

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
