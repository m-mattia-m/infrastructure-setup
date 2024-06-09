### Entrypoint

entrypoint:
	@echo ">>> choose a valid script: startup, shutdown"
	@echo "---------- before startup, set the config.env  ----------"

### Environment variables

export ARCH := $(shell dpkg --print-architecture)
export CODENAME := $(shell lsb_release -cs)
# export config := $(shell cat config.env)
include config.env

### Helpers


### Scripts

startup:
	@echo "--------------------------------------------------"
	@echo "         Start and build infrastrcuture           "
	@echo "--------------------------------------------------"
	@make init
	@make environment
	@make start-caddy
	@make start-portainer
	@make start-invoiceplane

shutdown:
	@echo "--------------------------------------------------"
	@echo "             Shutdown infrastrcuture              "
	@echo "--------------------------------------------------"
	@make stop-caddy
	@make stop-portainer

environment:
	@echo "--------------------------------------------------"
	@echo "                 Set environment                  "
	@echo "--------------------------------------------------"
	@echo "------------- Set canny environment --------------"
	@echo "\
		CADDY_BASE_URL=\"$(CADDY_BASE_URL)\"\n\
		CADDY_TLS_EMAIL=\"$(CADDY_TLS_EMAIL)\"\n\
	" | sed 's/^[[:space:]]*//g' > ./caddy/.env
	@echo "----------- Set portainer environment ------------"
	@echo "\
		BASE_URL=$(PORTAINER_BASE_URL)\n\
	" | sed 's/^[[:space:]]*//g' > ./portainer/.env

init:
	@echo "--------------------------------------------------"
	@echo "                  Initialization                  "
	@echo "--------------------------------------------------"
	@echo "-------------- default installations -------------"
	sudo apt install -y gnome-terminal --fix-missing
	sudo apt update --fix-missing
	sudo apt-get clean && sudo apt-get update
	sudo apt install software-properties-common curl apt-transport-https ca-certificates -y
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-archive-keyring.gpg
	sudo apt install openssh-server -y
	sudo ufw allow ssh
	@echo "--------------- ssh configurations ---------------"
	sudo systemctl status ssh | grep -w 'Active'
	ip addr show | grep -w inet | grep -v 127.0.0.1 | grep -v '172\.'
	@echo "--------- configurations docker registry ---------"
	sudo add-apt-repository "deb [arch=$(ARCH)] https://download.docker.com/linux/ubuntu $(CODENAME) stable" -y
	@echo "---------- docker desktop installations ----------"
	sudo apt install docker-ce docker-ce-cli containerd.io uidmap -y
	sudo systemctl status docker --no-pager
	@echo "----------------- go installation ----------------"
	sudo snap install go --classic
	@echo "-------------------- versions --------------------"
	docker compose version
	docker --version
	docker version
	go version


start-caddy:
	@echo "--------------------------------------------------"
	@echo "                   Start Caddy                    "
	@echo "--------------------------------------------------"
	docker network create caddy
	docker compose -f ./caddy/docker-compose.yaml up -d
	
start-portainer:
	@echo "--------------------------------------------------"
	@echo "                 Start Portainer                  "
	@echo "--------------------------------------------------"
	docker compose -f ./portainer/docker-compose.yaml up -d

start-invoiceplane:
	@echo "--------------------------------------------------"
	@echo "                Start InvoicePlane                "
	@echo "--------------------------------------------------"
	./buildmeup.sh
	./startmeup.sh

up-all:
	@echo "--------------------------------------------------"
	@echo "                      Up all                      "
	@echo "--------------------------------------------------"
	@make up-caddy
	@make up-portainer

up-caddy:
	@echo "--------------------------------------------------"
	@echo "                     Up Caddy                     "
	@echo "--------------------------------------------------"
	docker compose -f ./caddy/docker-compose.yaml up -d
	
up-portainer:
	@echo "--------------------------------------------------"
	@echo "                   Up Portainer                   "
	@echo "--------------------------------------------------"
	docker compose -f ./portainer/docker-compose.yaml up -d

up-invoiceplane:
	@echo "--------------------------------------------------"
	@echo "                  Up InvoicePlane                 "
	@echo "--------------------------------------------------"
	./startmeup.sh

stop-all:
	@echo "--------------------------------------------------"
	@echo "                     stop all                     "
	@echo "--------------------------------------------------"
	@make stop-caddy
	@make stop-portainer
	
stop-caddy:
	@echo "--------------------------------------------------"
	@echo "                    Stop Caddy                    "
	@echo "--------------------------------------------------"
	docker compose -f ./caddy/docker-compose.yaml down
	
stop-portainer:
	@echo "--------------------------------------------------"
	@echo "                  Stop Portainer                  "
	@echo "--------------------------------------------------"
	docker compose -f ./portainer/docker-compose.yaml down
