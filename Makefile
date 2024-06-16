### Entrypoint

entrypoint:
	@echo ">>> choose a valid script: generate-environment, install-ansible, new-node"
	@echo "---------- before startup, set the config.env  ----------"

### Environment variables

include config.env

generate-environment:
	@echo "--------------------------------------------------"
	@echo "                 Set environment                  "
	@echo "--------------------------------------------------"
	@echo "------------ Set traefik environment -------------"
	@echo "\
		TRAEFIK_DASHBOARD_CREDENTIALS=\"$(TRAEFIK_DASHBOARD_CREDENTIALS)\"\n\
		INFOMANIAK_ACCESS_TOKEN=\"$(INFOMANIAK_ACCESS_TOKEN)\"\n\
		ANSIBLE_USER=\"$(ANSIBLE_USER)\"\n\
	" | sed 's/^[[:space:]]*//g' > ./services/traefik/.env

install-ansible:
	@echo "--------------------------------------------------"
	@echo "                 Install ansible                  "
	@echo "--------------------------------------------------"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew install ansible
	brew install ansible-lint


new-node:
	@echo "--------------------------------------------------"
	@echo "           Setup new node with ansible            "
	@echo "--------------------------------------------------"
	ansible-playbook -i ./ansible/hosts.ini ./ansible/playbook.yaml