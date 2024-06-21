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
	" | sed 's/^[[:space:]]*//g' > ./services/traefik/.env
	@echo "------------- Set shlink environment -------------"
	@echo "\
		SHLINK_FQDN=\"$(SHLINK_FQDN)\"\n\
		SHLINK_DB_NAME=\"$(SHLINK_DB_NAME)\"\n\
		SHLINK_DB_USER=\"$(SHLINK_DB_USER)\"\n\
		SHLINK_DB_PASSWORD=\"$(SHLINK_DB_PASSWORD)\"\n\
		SHLINK_GEOLITE_LICENSE_KEY=\"$(SHLINK_GEOLITE_LICENSE_KEY)\"\n\
		SHLINK_INITIAL_API_KEY=\"$(SHLINK_INITIAL_API_KEY)\"\n\
		SHLINK_SERVER_URL=\"$(SHLINK_SERVER_URL)\"\n\
	" | sed 's/^[[:space:]]*//g' > ./services/shlink/.env
	@echo "--------- Set invoiceplane environment -----------"
	@echo "\
		INVOICEPLANE_HOST=\"$(INVOICEPLANE_HOST)\"\n\
		INVOICEPLANE_DB_USER=\"$(INVOICEPLANE_DB_USER)\"\n\
		INVOICEPLANE_DB_PASSWORD=\"$(INVOICEPLANE_DB_PASSWORD)\"\n\
		INVOICEPLANE_DB_NAME=\"$(INVOICEPLANE_DB_NAME)\"\n\
	" | sed 's/^[[:space:]]*//g' > ./services/invoiceplane/.env
	@echo "----------- Set portainer environment ------------"
	@echo "\
		PORTAINER_BASE_URL=\"$(PORTAINER_BASE_URL)\"\n\
	" | sed 's/^[[:space:]]*//g' > ./services/portainer/.env
	@echo "------------ Set backup environment --------------"
	@echo "\
		BACKUP_S3_HOST=\"$(BACKUP_S3_HOST)\"\n\
		BACKUP_S3_REGION=\"$(BACKUP_S3_REGION)\"\n\
		BACKUP_S3_BUCKET_NAME=\"$(BACKUP_S3_BUCKET_NAME)\"\n\
		BACKUP_S3_KEY_ID=\"$(BACKUP_S3_KEY_ID)\"\n\
		BACKUP_S3_ACCESS_KEY=\"$(BACKUP_S3_ACCESS_KEY)\"\n\
	" | sed 's/^[[:space:]]*//g' > ./services/backup/.env


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