### Entrypoint

entrypoint:
	@echo "---------- Set the config.env before you start the ansible playbook  ----------"
	@echo ">>> choose a valid script"
	@echo "- install-ansible"
	@echo "- generate-environment"
	@echo "- new-node"
	@echo "- new-clean-node"
	@echo "- new-restored-node"
	@echo "     -> selects your latest backup"
	@echo "- new-restored-node-selected-backup"
	@echo "     -> define the name of your backup you want to restore in the command like: 'make new-restored-node-selected-backup NAME=\"2024-backup\"' "
	@echo "-------------------------------------------------------------------------------"

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
	@echo "---------- Set DB cluster environment ------------"
	@echo "\
		DB_CLUSTER_ROOT_PASSWORD=\"$(DB_CLUSTER_ROOT_PASSWORD)\"\n\
	" | sed 's/^[[:space:]]*//g' > ./services/database-cluster/.env
	@echo "------------- Set shlink environment -------------"
	@echo "\
		SHLINK_DB_NAME=\"$(SHLINK_DB_NAME)\"\n\
		SHLINK_DB_USER=\"$(SHLINK_DB_USER)\"\n\
		SHLINK_DB_PASSWORD=\"$(SHLINK_DB_PASSWORD)\"\n\
		SHLINK_GEOLITE_LICENSE_KEY=\"$(SHLINK_GEOLITE_LICENSE_KEY)\"\n\
		SHLINK_INITIAL_API_KEY=\"$(SHLINK_INITIAL_API_KEY)\"\n\
		SHLINK_SERVER_FQDN=\"$(SHLINK_SERVER_FQDN)\"\n\
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

set-ansible-varialbes:
	@echo "--------------------------------------------------"
	@echo "              Set ansible variables               "
	@echo "--------------------------------------------------"
	@echo "  vars:" >> ansible/playbook.yaml
	@echo "    allowed_dyn_dns: \"$(ALLOWED_DYN_DNS)\"" >> ansible/playbook.yaml
	@echo "    s3_bucket_name: \"$(BACKUP_S3_BUCKET_NAME)\"" >> ansible/playbook.yaml
	@echo "    s3_endpoint_url: \"$(BACKUP_S3_HOST)\"" >> ansible/playbook.yaml
	@echo "    s3_access_id: \"$(BACKUP_S3_KEY_ID)\"" >> ansible/playbook.yaml
	@echo "    s3_access_key: \"$(BACKUP_S3_ACCESS_KEY)\"" >> ansible/playbook.yaml
	@echo "    db_cluster_root_password: \"$(DB_CLUSTER_ROOT_PASSWORD)\"" >> ansible/playbook.yaml
	@echo "    invoiceplane_db_password: \"$(INVOICEPLANE_DB_PASSWORD)\"" >> ansible/playbook.yaml
	@echo "    shlink_db_password: \"$(SHLINK_DB_PASSWORD)\"" >> ansible/playbook.yaml
	@echo "    shlink_ui_fqdn: \"$(SHLINK_UI_FQDN)\"" >> ansible/playbook.yaml
	@echo "    shlink_server_fqdn: \"$(SHLINK_SERVER_FQDN)\"" >> ansible/playbook.yaml
	@echo "    shlink_server_url: \"$(SHLINK_SERVER_URL)\"" >> ansible/playbook.yaml
	@echo "    invoiceplane_fqdn: \"$(INVOICEPLANE_FQDN)\"" >> ansible/playbook.yaml
	@echo "    ca_server: \"$(CA_SERVER)\"" >> ansible/playbook.yaml
	@echo "    allow_list_files_to_update:" >> ansible/playbook.yaml
	@echo "      - \"/home/{{ ansible_user }}/infrastructure/services/whoami/docker-compose.yaml\"" >> ansible/playbook.yaml
	@echo "      - \"/home/{{ ansible_user }}/infrastructure/services/shlink/docker-compose.yaml\"" >> ansible/playbook.yaml
	@echo "      - \"/home/{{ ansible_user }}/infrastructure/services/portainer/docker-compose.yaml\"" >> ansible/playbook.yaml
	@echo "      - \"/home/{{ ansible_user }}/infrastructure/services/invoiceplane/docker-compose.yaml\"" >> ansible/playbook.yaml
	@echo "      - \"/home/{{ ansible_user }}/infrastructure/services/traefik/docker-compose.yaml\"" >> ansible/playbook.yaml

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
	$(MAKE) set-ansible-varialbes
	ansible-playbook -i ./ansible/hosts.ini ./ansible/playbook.yaml --extra-vars "restore_backup=false"

new-clean-node:
	@echo "--------------------------------------------------"
	@echo "           Setup new node with ansible            "
	@echo "--------------------------------------------------"
	$(MAKE) set-ansible-varialbes
	ansible-playbook -i ./ansible/hosts.ini ./ansible/playbook.yaml --extra-vars "restore_backup=false"

new-restored-node:
	@echo "--------------------------------------------------"
	@echo "    Setup node with last backup through ansible   "
	@echo "--------------------------------------------------"
	$(MAKE) set-ansible-varialbes
	ansible-playbook -i ./ansible/hosts.ini ./ansible/playbook.yaml --extra-vars "restore_backup=true"

new-restored-node-selected-backup:
	@echo "--------------------------------------------------"
	@echo "    Setup node with last backup through ansible   "
	@echo "--------------------------------------------------"
	$(MAKE) set-ansible-varialbes
	$(MAKE) entrypoint NAME=my-latest-backup
	ansible-playbook -i ./ansible/hosts.ini ./ansible/playbook.yaml --extra-vars "restore_backup=true restore_backup_name='$(NAME)'"
