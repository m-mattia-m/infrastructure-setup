# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Create a udev rule for Docker socket permissions:
echo 'ACTION=="add", KERNEL=="docker", RUN+="/bin/chmod 666 /var/run/docker.sock"' | sudo tee /etc/udev/rules.d/90-docker.sock.rules > /dev/null
sudo udevadm control --reload-rules && sudo udevadm trigger

# Ensure Docker socket permissions for the current session:
sudo chmod 666 /var/run/docker.sock
