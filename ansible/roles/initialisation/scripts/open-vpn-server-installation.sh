sudo chmod +x /var/lib/dpkg/lock-frontend
sudo chmod +x /var/lib/dpkg/lock
sudo apt update && apt -y install ca-certificates wget net-tools gnupg
sudo wget https://as-repository.openvpn.net/as-repo-public.asc -qO /etc/apt/trusted.gpg.d/as-repository.asc
sudo echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/as-repository.asc] http://as-repository.openvpn.net/as/debian noble main">/etc/apt/sources.list.d/openvpn-as-repo.list
sudo apt update && apt -y install openvpn-as
