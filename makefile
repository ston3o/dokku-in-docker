.PHONY: install run remove enter

install: ## Install
	@ docker build -t dokku .

run: ## Run
	@ docker run -d --name dokku --privileged -it -p 80:80 -p 22 dokku

uninstall: ## Uninstall
	@ docker rm -f dokku

enter:
	@ docker exec -it dokku bash

logs:
	@ docker logs -f dokku
