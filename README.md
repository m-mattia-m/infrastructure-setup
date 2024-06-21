# Node infrastructure

Sometime an error occurs during your first run, then you have to delete the files and directory: `infrastructure` and `open-vpn-access-server-log.txt`. If there are some container already started kill and remove them all. You have to check if the OpenVPN server is already installed, if yes you have to make a backup from your credentials-file: `cp open-vpn-access-server-log.txt open-vpn-access-server-log.cp.txt` because it will be overwritten. \

## Replacements

* REPLACE_ME_WITH_YOUR_HOSTNAME -> replace with your VPN host such as `vpn.domain.com`
