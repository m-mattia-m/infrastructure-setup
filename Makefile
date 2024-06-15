### Entrypoint

entrypoint:
	@echo ">>> choose a valid script: startup, shutdown"
	@echo "---------- before startup, set the config.env  ----------"

### Environment variables

include config.env

environment:
	@echo "--------------------------------------------------"
	@echo "                 Set environment                  "
	@echo "--------------------------------------------------"
	@echo "------------ Set traefik environment -------------"
	@echo "\
		TRAEFIK_DASHBOARD_CREDENTIALS=\"$(TRAEFIK_DASHBOARD_CREDENTIALS)\"\n\
		CADDY_TLS_EMAIL=\"$(CADDY_TLS_EMAIL)\"\n\
	" | sed 's/^[[:space:]]*//g' > ./services/traefik/