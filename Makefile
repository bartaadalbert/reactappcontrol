# Files and directories
TMPDIR = "/tmp"
DEFF_MAKER = Makefolder/
CUR_DIR = $(shell echo "${PWD}")

# Text colors
YELLOW = "\033[1;33m"
RED = "\033[0;31m"
GREEN = "\033[0;32m"
BLUE = "\033[0;34m"

# Message colors
_SUCCESS := "\033[32m[%s]\033[0m %s\n"
_DANGER := "\033[31m[%s]\033[0m %s\n"

# String generation
STR_LENGTH := 121
RAND_STR := $(shell LC_ALL=C tr -dc 'A-Za-z0-9!,-.+?:@^_~' </dev/urandom | head -c $(STR_LENGTH))

# File and path settings
FILE_NAME_CHECK = anyfilename
PATH_TO_FILE = $(DEFF_MAKER)$(FILE_NAME_CHECK)
GITIGNORE_STATIC = $(DEFF_MAKER)git/gitignorestatic
DOCKER_FILE_DIR := dockerfiles
VERSION_FILE := $(DEFF_MAKER)version/version.txt
API_KEYS := $(DEFF_MAKER)api_keys.conf
DOCKER_APP_ENV_STAGING := ${DOCKER_FILE_DIR}/.env.stg
APP_DOCKERFILE_STAGING := ${DOCKER_FILE_DIR}/stg.Dockerfile
REACT_PUB_KEYFILE := ${DEFF_MAKER}docker/react_pub_api_key.txt 

# Scripts
SCRIPT_VERSION:= $(DEFF_MAKER)version/version.sh
SCRIPT_GDD := $(DEFF_MAKER)godaddy/gdd.sh
SCRIPT_NGINX := $(DEFF_MAKER)nginx/nginxgenerator.sh
SCRIPT_NGINX_UPSTREAM := $(DEFF_MAKER)nginx/nginxgenerator_upstream.sh
SCRIPT_DOCKER_NGINX := $(DEFF_MAKER)docker/docker_nginx_conf.sh
SCRIPT_DOCKER_NGINX_UPSTREAM := $(DEFF_MAKER)docker/docker_nginx_conf_upstream.sh
SCRIPT_CHANGE_COMPOSE := $(DEFF_MAKER)docker/change_compose.sh
SCRIPT_DOCKER_CONTAINER_INFO := $(DEFF_MAKER)docker/docker_container_info.sh
SCRIPT_PM2 := $(DEFF_MAKER)pm2/pm2creator.sh
SCRIPT_INSTALL_DOCKER_DOCKER_COMPOSE := $(DEFF_MAKER)docker/install_docker_docker_compose.sh
SCRIPT_GIT := $(DEFF_MAKER)git/gitrepo.sh
SCRIPT_GITHUB_ACCESS := $(DEFF_MAKER)git/check_github_access.sh
SCRIPT_GIT_WEBHOOK_URL := $(DEFF_MAKER)git/create_webhook.sh
SCRIPT_GIT_ACTION_SETTINGS := $(DEFF_MAKER)git/set_secrets.sh
SCRIPT_GIT_IGNORE := $(DEFF_MAKER)git/gitignore_create.sh
SCRIPT_DO_CLI := $(DEFF_MAKER)digitalocean/install_doctl.sh
SCRIPT_DO_DROPLET := $(DEFF_MAKER)digitalocean/create_droplet.sh
SCRIPT_DO_CHECK_CLI_INSTALL := $(DEFF_MAKER)digitalocean/check_install_dokctl.sh
SCRIPT_DO_DROPLET_DELETE := $(DEFF_MAKER)digitalocean/delete_droplet.sh
SCRIPT_DO_DOCKER_INSTALL := $(DEFF_MAKER)digitalocean/install_docker.sh


REACT_APP_API_KEY := $(shell cat ${REACT_PUB_KEYFILE})
# Version settings
VARIABLE_VERSION := $(shell cat ${VERSION_FILE})
DEFVERSION := 1.0.0
VERSION := $(if $(VARIABLE_VERSION),$(VARIABLE_VERSION),$(DEFVERSION))
VERSION_ARGUMENT := feature
NEWVERSION := $(shell $(SCRIPT_VERSION) $(VERSION) $(VERSION_ARGUMENT))
LOCAL_BUILD := false

####################################
# !!!!!! DEVELOP OR PRODUCT !!!!!! #
####################################

DEV_MODE ?= 1
ifeq ($(DEV_MODE),1)
include makefile_dev.mk
else
include makefile_prod.mk
endif

####################################
# !!!!!! DEVELOP OR PRODUCT !!!!!! #
####################################

SSH_SERVER := $(REMOTE_USER)@$(REMOTE_HOST)
SSH_SERVER_IP := $(REMOTE_USER)@$(IP)
PATH_TO_PROJECT := $(APP_NAME)

#RSYNC SETTINGS
RSYNC = rsync
RSYNC_OPTIONS = -avP --exclude-from=$(DEFF_MAKER).rsyncignore
SOURCE_DIR = $(APP_NAME)
DESTINATION_DIR = $(SSH_SERVER):$(RSYNC_DESTINATION_DIR)

# IP and domain settings
IP := $(shell dig $(DOMAIN) +short @resolver1.opendns.com)
PROXY_PASS := http:\/\/127.0.0.1:$(PORT_NGINX_FINAL)
PROXY_PASS_UPSTREAM_BACKUP := http:\/\/127.0.0.1:$(FINAL_PORT_STAGING)

ifeq ($(strip $(SUBDOMAIN_NAME)),)
    SUBDOMAIN = $(DOMAIN)
else
    SUBDOMAIN = $(SUBDOMAIN_NAME).$(DOMAIN)
endif

# Git settings
GIT_MESSAGE := app created, DEFAULT GIT_message
GITSSH := git@github.com:westcast24/$(APP_NAME).git
GIT_EMAIL := office@westcast-24.com
GIT_NAME := Westcast 24

# Docker Image names
APP_IMAGE_NAME := $(APP_MODE)_$(APP_NAME)
REDIS_IMAGE_NAME := redis_$(APP_NAME)
MEMCACHE_IMAGE_NAME := memcache_$(APP_NAME)

# Docker nginx conf
NGINX_DOCKER_CONF := ${DOCKER_FILE_DIR}/nginx/$(APP_IMAGE_NAME).conf
NGINX_CONF := $(DEFF_MAKER)nginx/$(SUBDOMAIN).conf
NGINX_CONF_FILE := $(SUBDOMAIN).conf

#Docker settings
DOCKER_NETWORK := $(APP_NAME)_net
DOCKER_COMPOSE := docker-compose
DOCKER_COMPOSE_FILE := $(APP_NAME)/$(APP_COMPOSEFILE)
DOCKER_CHANGE_COMPOSE_FILE := $(DEFF_MAKER)docker/$(APP_IMAGE_NAME).compose
COMPOSE_FILE_STUB_NAME := $(APP_MODE)_app_docker_compose.stub

# PM2 config js
PM2_CONFIG := $(APP_NAME).config.js

# Image tag settings
NO_IMAGE_TAG := $(VERSION)
ifeq ($(NO_IMAGE_TAG),"")
APP_IMAGE_TAG := latest
else
APP_IMAGE_TAG := $(VERSION)
endif

IMAGE := $(APP_IMAGE_NAME):$(APP_IMAGE_TAG)
DEBUG := $(DEV_MODE)
SECRET_KEY := $(RAND_STR)
APP_API_URL := $(APP_API_URL)
APP_PORT := $(FINAL_PORT)
APP_PORT_STAGING := $(FINAL_PORT_STAGING)
APP_MODE_STAGING := stg
APP_IMAGE_TAG_STAGING := latest

ENV_VARS_DOTENV = APP_DOCKERFILE APP_IMAGE_TAG APP_IMAGE_NAME REACT_COMMAND PORT_APP DOCKER_APP_ENV REDIS_IMAGE_NAME PORT_REDIS DOCKER_NETWORK APP_DOCKERFILE_STAGING DOCKER_APP_ENV_STAGING PORT_APP_STAGING REACT_COMMAND_STAGING REACT_APP_API_KEY FINAL_PORT_STAGING
ENV_VARS_APP_ENV = DEBUG APP_MODE APP_API_URL APP_PORT APP_IMAGE_TAG
ENV_VARS_APP_ENV_STAGING = DEBUG APP_MODE_STAGING APP_API_URL APP_PORT_STAGING APP_IMAGE_TAG_STAGING FINAL_PORT_STAGING
FOLDERS = docker git godaddy nginx version digitalocean pm2

ARRAY = ""
define COLLECT_VARIABLES
  ARRAY += "$(1)=$(value $(1));"
endef

.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@make bash_executable

.DEFAULT_GOAL := help


checker: ## This check the input enabel.
	@read -p "Are you sure? [y/N] " ans && ans=$${ans:-N} ; \
	if [ $${ans} = y ] || [ $${ans} = Y ]; then \
		printf $(_SUCCESS) "YES" ; \
	else \
		printf $(_DANGER) "NO, changes not made" ; \
		exit 1; \
	fi
	@echo 'Next steps...'


file_check: ## CHECK IF FILE EXISTING in MAIN DEFF_MAKER OR CHANGE THE PATH_TO_FILE VARIABLE
	@echo $(PATH_TO_FILE)
	@if [[ ! -f $(PATH_TO_FILE) ]]; then \
		printf $(_DANGER) "FILE NOT EXIST"; \
		exit 1; \
	else \
		printf $(_SUCCESS) "FILE EXIST"; \
	fi

check_ssh_access: ## Check your ssh connection to remote server
	@echo "Checking if the server is alive at $(DOMAIN) or $(IP)..."
	@if nc -z -v -w $(TIMEOUT) $(DOMAIN) 22 >/dev/null 2>&1 || nc -z -v -w $(TIMEOUT) $(IP) >/dev/null 2>&1; then \
		echo "Server is alive at $(IP)"; \
		echo "Checking SSH access for $(SSH_SERVER)..."; \
		if ssh -o ConnectTimeout=$(TIMEOUT) -o BatchMode=yes -q $(SSH_SERVER) exit 2>/dev/null; then \
			echo $(GREEN)"SSH access is available at $(SSH_SERVER)"; \
		elif [ ! -z "$(IP)" ] && ssh -o ConnectTimeout=$(TIMEOUT) -o BatchMode=yes -q $(SSH_SERVER_IP) exit 2>/dev/null; then \
			echo $(GREEN)"SSH access is available at $(SSH_SERVER_IP)"; \
			echo "Create A record for domain $(DOMAIN) with IP $(IP)"; \
			bash $(SCRIPT_GDD) $(DOMAIN) "@" $(IP); \
		else \
			echo $(RED)"SSH access is not available."; \
			read -p "Do you want to add your SSH key to the remote server? (y/n): " answer; \
			if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
				echo $(BLUE)"Adding SSH key to the remote server..."; \
				ssh-copy-id $(SSH_SERVER_IP); \
			else \
				echo $(YELLOW)"Skipping adding SSH key to the remote server."; \
			fi \
		fi \
	else \
		echo $(RED)"Server is not alive at $(SSH_SERVER) or $(IP)"; \
		read -p "Do you want to create a server? (y/n): " create_server_answer; \
		if [ "$$create_server_answer" = "y" ] || [ "$$create_server_answer" = "Y" ]; then \
			echo "Creating a server..."; \
			make check_ip; \
		else \
			echo $(YELLOW)"Skipping server creation."; \
		fi \
	fi


check_ip: ## Verify if the domain's IP address is accessible
	@if [ -z "$(IP)" ]; then \
		echo $(YELLOW)"IP is empty, try creating a server..."; \
		make install_doctl; \
		make create_droplet; \
		make check_ssh_access; \
	else \
		echo $(GREEN)"IP is not empty: $(IP). You are ready to proceed."; \
	fi
	

#NGINX DOMAIN CONFIG START

create_nginx: ## Create an nginx config with proxypass and servername
	@bash $(SCRIPT_NGINX) $(SUBDOMAIN) "$(PROXY_PASS)"

create_ssl: ## Create ssl with certbot for our nginx conf in our server
	@ssh $(SSH_SERVER) "ls -lah /etc/nginx/sites-enabled/"
	@echo $(YELLOW)IF you dont see $(NGINX_CONF_FILE) continue...
	@echo $(RED)DONT forget set GODADDY API keys...
	@make checker
	@if [ ! -f $(NGINX_CONF) ]; then \
		printf $(_DANGER)"The NGINX conf not exist, CREATE IT WITH: make create_nginx" ;\
		make create_nginx;\
	fi
	@make create_subdomain
	@echo $(YELLOW)Please wait ...
	@sleep 60
	@ssh $(SSH_SERVER) "apt install -y nginx"
	@scp $(NGINX_CONF) $(SSH_SERVER)":/etc/nginx/sites-available/"
	@ssh $(SSH_SERVER) "rm -f /etc/nginx/sites-enabled/$(NGINX_CONF_FILE)"
	@ssh $(SSH_SERVER) "ln -s /etc/nginx/sites-available/$(NGINX_CONF_FILE) /etc/nginx/sites-enabled/$(NGINX_CONF_FILE)"
	@ssh $(SSH_SERVER) "systemctl restart nginx"
	@ssl_exists=$$(ssh $(SSH_SERVER) "test -f /etc/letsencrypt/live/$(SUBDOMAIN)/fullchain.pem && echo 'yes' || echo 'no'") ;\
	if [ "$$ssl_exists" == "no" ]; then \
		ssh $(SSH_SERVER) "apt-get install -y certbot" ;\
		ssh $(SSH_SERVER) "certbot --nginx -d $(SUBDOMAIN)" ;\
		ssh $(SSH_SERVER) "certbot renew --dry-run" ;\
	else \
		echo $(YELLOW)"SSL certificate for $(SUBDOMAIN) already exists. Skipping SSL creation." ;\
	fi
	@make delete_nginx_conf


delete_ssl: ## This will delete our ssl configs with nginx config
	@read -p "Are you sure you want to delete SSL and Nginx configurations for $(NGINX_CONF_FILE)? (y/n): " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		ssh $(SSH_SERVER) "rm -f /etc/nginx/sites-available/$(NGINX_CONF_FILE)"; \
		ssh $(SSH_SERVER) "rm -f /etc/nginx/sites-enabled/$(NGINX_CONF_FILE)"; \
		ssh $(SSH_SERVER) "rm -f /etc/letsencrypt/live/$(SUBDOMAIN)"; \
		ssh $(SSH_SERVER) "systemctl restart nginx"; \
		echo $(RED)"SSL and Nginx configurations for $(NGINX_CONF_FILE) have been deleted."; \
	else \
		echo $(YELLOW)"Skipping deletion of SSL and Nginx configurations."; \
	fi


delete_nginx_conf: ## Delete nginx config with conf name
	@read -p "Are you sure you want to delete the Nginx configuration $(NGINX_CONF)? (y/n): " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		rm -f $(NGINX_CONF); \
		echo $(RED)The Nginx configuration $(NGINX_CONF) was deleted; \
	else \
		echo $(YELLOW)"Skipping deletion of the Nginx configuration."; \
	fi

create_subdomain: ## This will create a subdomain nam=app_name in our main domain, 4 param is a specific IP
	@bash $(SCRIPT_GDD) $(DOMAIN) $(SUBDOMAIN_NAME) $(IP)

delete_subdomain: ## Delete the subdomain with this app_name
	@read -p "Are you sure you want to delete the subdomain $(SUBDOMAIN_NAME) on $(DOMAIN)? (y/n): " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		bash $(SCRIPT_GDD) $(DOMAIN) $(SUBDOMAIN_NAME) "DELETE"; \
		echo $(RED)"Subdomain $(SUBDOMAIN_NAME) on $(DOMAIN) was deleted"; \
	else \
		echo $(YELLOW)"Skipping deletion of the subdomain."; \
	fi

#NGINX DOMAIN CONFIG END


#APP CONFIGURATION START
collect_app_env: ## USE CAREFULLY CREATE ENV FILES APPENV
	@echo "" > $(APP_NAME)/$(DOCKER_APP_ENV)
	$(foreach var,$(ENV_VARS_APP_ENV),echo "$(var)=$(value $(var))" >> $(APP_NAME)/$(DOCKER_APP_ENV);)

collect_app_env_stg: ## USE CAREFULLY CREATE ENV FILES APPENV STAGING
	@echo "" > $(APP_NAME)/$(DOCKER_APP_ENV_STAGING)
	$(foreach var,$(ENV_VARS_APP_ENV_STAGING),echo "$(var)=$(value $(var))" >> $(APP_NAME)/$(DOCKER_APP_ENV_STAGING);)

collect_dot_env: ## USE CAREFULLY CREATE ENV FILES DOTENV
	@echo "" > $(APP_NAME)/.env
	$(foreach var,$(ENV_VARS_DOTENV),echo "$(var)=$(value $(var))" >> $(APP_NAME)/.env;)

create_directories: ## Create necessary directories
	@echo $(BLUE)Creating directories...
	@mkdir -p $(APP_NAME)/$(DOCKER_FILE_DIR)/nginx
	@mkdir -p $(APP_NAME)/.github/workflows

copy_files: create_directories ## Copy necessary files
	@echo $(BLUE)Copying files...
	@cp $(DEFF_MAKER)docker/$(APP_MODE)_app_docker.stub $(APP_NAME)/$(APP_DOCKERFILE)
	@cp $(DEFF_MAKER)docker/$(APP_MODE)_stg_app_docker.stub $(APP_NAME)/$(APP_DOCKERFILE_STAGING)
	@cp $(DEFF_MAKER)docker/nginx_docker.stub $(APP_NAME)/$(NGINX_DOCKERFILE_NAME)
	@cp $(DEFF_MAKER)git/deploy.yml $(APP_NAME)/.github/workflows/deploy.yml


preconfig: ## Add all needed files
	@if [ -d $(APP_NAME) ]; then \
		make copy_files; \
		make set_compose; \
		cp $(DOCKER_CHANGE_COMPOSE_FILE) $(APP_NAME)/$(APP_COMPOSEFILE); \
		make collect_dot_env; \
		make collect_app_env; \
		make collect_app_env_stg; \
		echo $(GREEN)"The preconfig is ready"; \
	else\
		echo $(RED)"The app folder $(APP_NAME) not exist, can't add configs"; \
	fi

delete_preconfig: ## THIS WILL DELETE OUR DOCKER CONFIGURATION
	@read -p "Are you sure you want to delete the Docker configs in $(APP_NAME)/$(DOCKER_FILE_DIR)? This action cannot be undone. [y/N]: " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		echo $(RED)"Deleting Docker configs..."; \
		rm -rf $(APP_NAME)/$(DOCKER_FILE_DIR); \
		rm -rf $(APP_NAME)/$(APP_COMPOSEFILE); \
		rm -rf $(APP_NAME)/.env; \
	else \
		echo $(YELLOW)"Operation canceled, Docker configs not deleted."; \
	fi


configure_docker: ## Configure Docker
	@make check_and_install_docker_docker_compose
	@make create_context
	@make check_ssh_access

deploy_github_actions: create_git_secrets ## Deploy the project to a remote server using GitHub Actions
	@echo $(GREEN)"Deploying the project with github actions, using rsync..."
	
deploy_git_webhook: create_gitwebhook  ## Deploy the project to a remote server using a Git webhook
	@echo $(GREEN)"Deploying the project with github webhooks, you need to setup on your server logic of your actions"

deploy_manual: ## Deploy the project locally using rsync
	@echo $(GREEN)"Deploying the project locally using rsync..."
	@make sync
	@echo $(GREEN)"Local deployment completed."
	@make rebuild

deploy: ## Deploy the project to a remote server, asking the user to choose the deployment method
	@echo "Choose the deployment method:"
	@echo "1. GitHub Actions"
	@echo "2. Git Webhook"
	@echo "3. Manual Deployment (rsync)"
	@echo "4. None (default)"
	@echo
	@read -p "Enter the number of your choice (1, 2, 3, or 4): " choice; \
	case $$choice in \
		1) make deploy_github_actions;; \
		2) make deploy_git_webhook;; \
		3) make deploy_manual;; \
		4) echo "No deployment method selected.";; \
		*) echo "Invalid choice. Please enter 1, 2, 3, or 4.";; \
	esac

deploy_stg: choose_context ## Deploy staging and prod or dev with tests
	@echo "Do you want to use staging for testing? (y/n): "; \
	read USE_STAGING; \
	if [ $$USE_STAGING = "y" ]; then \
		docker build -t stg_${APP_IMAGE_NAME}:latest -f $(APP_NAME)/${APP_DOCKERFILE_STAGING} ../ ; \
		docker run -d -p ${PORT_APP_STAGING} --name stg_${APP_IMAGE_NAME} --hostname stg_${APP_IMAGE_NAME} --network $(DOCKER_NETWORK) stg_${APP_IMAGE_NAME}; \
		STAGING_STATUS=$$(docker inspect -f '{{.State.Status}}' stg_${APP_IMAGE_NAME}); \
		if [ $$STAGING_STATUS != "running" ]; then \
			echo $(RED)"Staging container failed to start. Aborting deployment."; \
			exit 1; \
		fi; \
	else \
		c=${APP_IMAGE_NAME}; \
		make rebuild; \
	fi


react_up: save_version preconfig context rebuild ## Preconfig change context and docker UP

react_up_stg: save_version preconfig context deploy_stg ## Preconfig change context and docker UP

create_pm2: ## Add pm2 config js to app folder
	@if [[ ! -d $(APP_NAME) ]]; then\
		echo $(RED)"Cant add pm2 config if APP not created before";\
		exit 1;\
	fi
	@if [[ ! -f $(APP_NAME)/$(PM2_CONFIG) ]]; then \
		bash $(SCRIPT_PM2) $(APP_NAME) "$(FINAL_PORT)"; \
		cp $(CUR_DIR)/$(DEFF_MAKER)pm2/$(PM2_CONFIG) $(APP_NAME); \
		echo $(BLUE)The config js was created and copied to APP folder; \
	else \
		read -p "The PM2 config file already exists. Do you want to overwrite it? [y/N]: " answer; \
		if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
			bash $(SCRIPT_PM2) $(APP_NAME) "$(FINAL_PORT)"; \
			cp $(CUR_DIR)/$(DEFF_MAKER)pm2/$(PM2_CONFIG) $(APP_NAME); \
			echo $(BLUE)The config js was created and copied to APP folder; \
		else \
			echo $(YELLOW)"Operation canceled, PM2 config not overwritten."; \
		fi \
	fi

bash_executable: ## Make all .sh files executable for our app
	@for folder in $(FOLDERS); do \
		sudo chmod u+x $(DEFF_MAKER)$$folder/*.sh; \
	done
	@echo $(GREEN)the bash files were made executable

sync: ## We will use rsync to copy our project to remote server
	@read -p "Do you want to sync your project to the remote server? [y/N]: " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		ssh $(SSH_SERVER) "mkdir -p $(RSYNC_DESTINATION_DIR)"; \
		$(RSYNC) $(RSYNC_OPTIONS) $(SOURCE_DIR) $(DESTINATION_DIR); \
		echo $(GREEN)"Project synced to the remote server."; \
	else \
		echo $(YELLOW)"Operation canceled, project not synced."; \
	fi

create_react_app: check_node ## Create react app
	@if [ ! -d $(APP_NAME) ]; then\
		read -p "Do you want to create REACT app $(APP_NAME) ? [y/N]: " answer; \
		if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
			cp $(GITIGNORE_STATIC) .gitignore; \
			make append_gitignore; \
			cat $(DOCKERIGNORE_STATIC) >> $(APP_NAME)/.dockerignore; \
			npx create-react-app $(APP_NAME); \
			echo $(BLUE)"The app folder $(APP_NAME) created successfully";\
		fi;\
	else\
		echo $(YELLOW)"The app folder $(APP_NAME) exist, nothing to do";\
	fi
	@make create_network
	@make preconfig


delete_app: ## THIS will remove our startproject with all data
	@read -p "Are you sure you want to delete the app $(APP_NAME)? This action cannot be undone. [y/N]: " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		rm -rf $(APP_NAME); \
		rm -rf .gitignore; \
		echo $(GREEN)"The app $(APP_NAME) was deleted"; \
	else \
		echo $(YELLOW)"Operation canceled, app and venv not deleted."; \
	fi

check_node:
	node_version=$(shell node -v | cut -c2-)
	echo "Node version found: $$node_version"
	@if [ `uname` = "Linux" ]; then \
		if ! [ -x "$(command -v node)" ]; then \
			sudo apt-get install -y nodejs; \
			sudo apt-get install -y npm; \
		fi \
	elif [ `uname` = "Darwin" ]; then \
		if ! [ -x "$(command -v node)" ]; then \
			brew install node; \
		fi \
	else \
		echo "Unsupported OS"; \
	fi

#APP CONFIGURATION END

# GIT COMMANDS START

create_gitignore: # Create gitignore dinamic
	@echo "" > .gitignore
	@cp $(GITIGNORE_STATIC) .gitignore
	@read -p "Do you want to append to an existing .gitignore file or create a new one? (append/new): " GITIGNORE_OPTION; \
	if [ "$$GITIGNORE_ACTION" = "new" ]; then \
		make append_gitignore; \
	else \
		if [ -f "$(APP_NAME)/.gitignore" ]; then \
			tmp_file=$$(bash $(SCRIPT_GIT_IGNORE) $(APP_NAME)); \
			cat $$tmp_file >> .gitignore; \
			rm $$tmp_file; \
		fi \
	fi; \
	

append_gitignore: ## Tsis will create a static gitignore for react app
	@echo "$(APP_NAME)/node_modules" >> .gitignore
	@echo "$(APP_NAME)/.pnp" >> .gitignore
	@echo "$(APP_NAME)/.pnp.js" >> .gitignore
	@echo "$(APP_NAME)/coverage" >> .gitignore
	@echo "$(APP_NAME)/build" >> .gitignore
	@echo "$(APP_NAME)/.DS_Store" >> .gitignore
	@echo "$(APP_NAME)/.env.local" >> .gitignore
	@echo "$(APP_NAME)/.env.development.local" >> .gitignore
	@echo "$(APP_NAME)/.env.test.local" >> .gitignore
	@echo "$(APP_NAME)/.env.production.local" >> .gitignore
	@echo "$(APP_NAME)/npm-debug.log*" >> .gitignore
	@echo "$(APP_NAME)/npm-debug.log*" >> .gitignore
	@echo "$(APP_NAME)/yarn-debug.log*" >> .gitignore
	@echo "$(APP_NAME)/yarn-error.log*" >> .gitignore
	@echo "$(APP_NAME)/.env*" >> .gitignore

github_access: ## Check the github access from local or remote server
	@read -p "Do you want to use a local server or remote server? (local/remote): " server_choice; \
	case $$server_choice in \
		local) \
			bash $(SCRIPT_GITHUB_ACCESS) $$server_choice;; \
		remote) \
			bash $(SCRIPT_GITHUB_ACCESS) $$server_choice $SSH_SERVER;; \
		*) \
			echo "Invalid choice. Please enter 'local' or 'remote'.";; \
	esac

create_repo: ## Create a GitHub repository private without a template
	@repo_exists=$$(bash $(SCRIPT_GIT) $(APP_NAME) "CHECK"); \
	if [ "$$repo_exists" == "no" ]; then \
		read -p "Do you want to create a new GitHub repository with the name $(APP_NAME)? [y/N]: " answer; \
		if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
			bash $(SCRIPT_GIT) $(APP_NAME); \
			echo $(BLUE)"The repo was created with the name $(APP_NAME)"; \
		else \
			echo $(YELLOW)"Operation canceled, repository not created."; \
		fi \
	else \
		echo $(RED)"A repository with the name $(APP_NAME) already exists. No changes were made."; \
	fi

delete_repo: ## Delete the GitHub repository with user and name set before
	@read -p "Do you want to delete the GitHub repository with the name $(APP_NAME)? [y/N]: " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		bash $(SCRIPT_GIT) $(APP_NAME) "DELETE"; \
		echo $(YELLOW)"The repo was deleted with the name $(APP_NAME)"; \
	else \
		echo $(YELLOW)"Operation canceled, repository not deleted."; \
	fi

create_gitwebhook: ## Create github webhook with django app url setted before
	@bash $(SCRIPT_GIT_WEBHOOK_URL) $(APP_NAME) $(GIT_WEBHOOK_URL)
	@echo $(BLUE)The webhook was created to reponame $(APP_NAME) with url $(GIT_WEBHOOK_URL)

delete_gitwebhook: ## DELETE github webhook
	@read -p "Are you sure you want to delete the webhook in repo $(APP_NAME) with URL $(GIT_WEBHOOK_URL)? [y/N]: " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		bash $(SCRIPT_GIT_WEBHOOK_URL) $(APP_NAME) $(GIT_WEBHOOK_URL) "DELETE"; \
		echo $(RED)"The webhook was deleted in repo $(APP_NAME) with url $(GIT_WEBHOOK_URL)"; \
	else \
		echo $(YELLOW)"Aborted delete git webhook."; \
	fi

git_init: ## ADD ssh pub key to git, this will be simple for the future using, and create an app in github
	$(eval GIT_EMAIL := $(shell git config --global user.email))
	$(eval GIT_NAME := $(shell git config --global user.name))
	@if [ -z "$(GIT_EMAIL)" ] || [ -z "$(GIT_NAME)" ]; then \
		echo $(RED)"Please set up your Git email and name using the following commands:"; \
		echo "git config --global user.email \"you@example.com\""; \
		echo "git config --global user.name \"Your Name\""; \
		exit 1; \
	fi
	@if [ -z $(APP_NAME) ]; then\
		echo $(RED)"The app name not configured";\
		exit 1;\
	fi
	@if [ -z $(GITSSH) ]; then\
		echo $(RED)"The git ssh repo not configured";\
		exit 1;\
	fi

	-@make create_repo
	@git init
	@git add .
	@git commit -m "$(VERSION)"
	@git remote add origin $(GITSSH)
	@git branch -M $(BRANCH)	
	@git push -u origin $(BRANCH)

git_push: ##Git add . and commit and push to branch, add tag
	@make save_version
	@git status
	-@git add .
	$(eval GIT_MESSAGE := $(shell read -p "Do you want to set a custom git message? (Current: $(GIT_MESSAGE)) " custom_message && echo $${custom_message:-$(GIT_MESSAGE)}))
	-@git commit -m "$(GIT_MESSAGE) with version $(VERSION)"
	-@git push -u origin $(BRANCH)

git_tag: ## This will tag our git with actual version 
	@git checkout $(BRANCH)
	@echo $(VERSION)
	@git tag $(VERSION)
	@git push --tags

create_git_secrets: ##This will create our secrets file and secrets for using github actions
	@echo "This will call our script set_secrets.sh for github"
	@read -p "Do you want to proceed? [y/N]: " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		bash $(SCRIPT_GIT_ACTION_SETTINGS) $(SECRETS_STRING) $(EXPECTED_VALUES_STRING) $(APP_NAME); \
	else \
		echo $(YELLOW)"Aborted github secrets."; \
	fi

# GIT COMMANDS END

#VERSION CONTROL START

save_version: check_version ## Save a new version with increment param VERSION_ARGUMENT=[1.0.0:major/feature/bug]
	@read -p "Do you want to save the new version $(NEWVERSION)? [y/N]: " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		echo $(NEWVERSION) > $(VERSION_FILE); \
		echo $(GREEN)"New version: $(NEWVERSION)"; \
	else \
		echo $(YELLOW)"Operation canceled, new version not saved."; \
	fi

check_version: ## Get the actual version
	@echo $(BLUE)current version: $(VERSION)

reset_version: clean_version ## This will generate new file with DEFVERSION or any VERSION
	@echo $(DEFVERSION) > $(VERSION_FILE)
	@echo $(RED)reset version: $(DEFVERSION)

clean_version: ## This will delete our version file, will set version to DEFVERSION 1.0.0 or what you give
	@read -p "Do you want to delete the version file? (y/n): " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		rm -f $(VERSION_FILE); \
		echo $(RED)"The version file was deleted from the app directory"; \
	else \
		echo $(YELLOW)"Skipping version file deletion."; \
	fi

#VERSION CONTROL END


#DOCKER COMMANDS START

check_and_install_docker_docker_compose: ## Check docker docker-compose and if not installed try install
	@command -v docker >/dev/null 2>&1 || { echo "Docker is not installed. Proceeding with installation..."; NEED_INSTALL=true; }
	@command -v docker-compose >/dev/null 2>&1 || { echo "Docker Compose is not installed. Proceeding with installation..."; NEED_INSTALL=true; }
	@if [ "$$NEED_INSTALL" = "true" ]; then \
		echo $(YELLOW)" Starting Docker and Docker Compose installation..."; \
		make install_docker_docker_compose; \
	else \
		echo $(GREEN)" Docker and Docker Compose are already installed."; \
	fi

install_docker_docker_compose: ## INSTALL DOCKER DOCKER-COMPOSE local or remote
	@bash $(SCRIPT_INSTALL_DOCKER_DOCKER_COMPOSE) $(IP)

set_compose: ## Enable set for the docker-compose file
	@read -p "Do you want to change the docker-compose file? (y/n): " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		echo $(BLUE)The compose file will change; \
		bash $(SCRIPT_CHANGE_COMPOSE) $(APP_IMAGE_NAME) $(COMPOSE_FILE_STUB_NAME) $(REDIS_IMAGE_NAME); \
		echo $(BLUE)The compose file was set; \
	else \
		echo $(YELLOW)"Skipping docker-compose file changes."; \
	fi

context: ##Get available docker context list
	-@docker context ls

images: ## Get all docker images
	-@docker images

ps: ## Get all runing docker containers
	-@docker ps -a 

choose_context:
	@read -p "Do you want to use Docker context locally or remotely (l/r)? " answer; \
	if [ "$$answer" = "l" ] || [ "$$answer" = "L" ]; then \
		echo $(YELLOW)"Setting Docker context to local..."; \
		make change_context DOCKER_CONTEXT=$(DOCKER_CONTEXT); \
	elif [ "$$answer" = "r" ] || [ "$$answer" = "R" ]; then \
		echo $(YELLOW)"Setting Docker context to remote..."; \
		make change_context DOCKER_CONTEXT=$(DOCKER_CONTEXT); \
	else \
		echo $(YELLOW)"Skipping Docker context change."; \
	fi

change_context: context ## Change the docker context to other server
	@echo $(BLUE)The docker context will change to $(DOCKER_CONTEXT)
	@read -p "Do you want to change the Docker context to $(DOCKER_CONTEXT)? (y/n): " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		docker context use $(DOCKER_CONTEXT); \
		echo $(YELLOW)The Docker context changed to $(DOCKER_CONTEXT); \
	else \
		echo $(YELLOW)"Skipping Docker context change."; \
	fi


create_context: ## Create new server docker context
	@read -p "Do you want to create a new Docker context named $(DOCKER_CONTEXT) at $(CONTEXT_HOST)? (y/n): " proceed; \
	if [ "$$proceed" = "y" ] || [ "$$proceed" = "Y" ]; then \
		docker context create $(DOCKER_CONTEXT) --description $(CONTEXT_DESCRIPTION) --docker $(CONTEXT_HOST); \
		echo $(BLUE)"The $(DOCKER_CONTEXT) was created at $(CONTEXT_HOST)"; \
		make change_context; \
	else \
		echo $(YELLOW)"Skipping Docker context creation."; \
	fi

delete_context: ## Delete the context
	@if docker context inspect $(DOCKER_CONTEXT) >/dev/null 2>&1; then \
		read -p "Do you want to delete the Docker context $(DOCKER_CONTEXT)? (y/n): " answer; \
		if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
			docker context rm $(DOCKER_CONTEXT); \
			echo $(RED)The $(DOCKER_CONTEXT) was deleted; \
		else \
			echo $(YELLOW)"Skipping Docker context deletion."; \
		fi \
	else \
		echo $(YELLOW)"Docker context $(DOCKER_CONTEXT) does not exist"; \
	fi

create_network: ## CREATE DOCKER NETWORK IF NOT EXIST
	@docker network ls
	@echo $(YELLOW)CHECK DOCKER NETWORK AND CREATE IT  WITH NAME $(DOCKER_NETWORK)
	@if [ "$(shell docker network ls | grep "${DOCKER_NETWORK}")" == "" ]; then \
		read -p "Do you want to create a Docker network with name $(DOCKER_NETWORK)? (y/n): " answer; \
		if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
			docker network create "${DOCKER_NETWORK}"; \
			echo $(BLUE)"DOCKER NETWORK WAS CREATED WITH NAME $(DOCKER_NETWORK)"; \
		else \
			echo $(YELLOW)"Skipping Docker network creation."; \
		fi \
	else \
		echo $(YELLOW)"DOCKER NETWORK WITH NAME $(DOCKER_NETWORK) EXIST"; \
	fi

delete_network: ## DELETE DOCKER NETWORK BY NAME
	@docker network ls
	@echo $(RED)DELETE DOCKER NETWORK WITH NAME $(DOCKER_NETWORK)
	@if [ "$(shell docker network ls | grep "${DOCKER_NETWORK}")" != "" ]; then \
		read -p "Do you want to delete the Docker network with name $(DOCKER_NETWORK)? (y/n): " answer; \
		if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
			docker network rm $(DOCKER_NETWORK); \
			echo $(RED)"DOCKER NETWORK WAS DELETED WITH NAME $(DOCKER_NETWORK)"; \
		else \
			echo $(YELLOW)"Skipping Docker network deletion."; \
		fi \
	else \
		echo $(YELLOW)"DOCKER NETWORK WITH NAME $(DOCKER_NETWORK) NOT EXIST, NOTHING TO DO"; \
	fi

create_docker_nginx: ## CREATE DOCKER NGINX CONF INSIDE DOCKER
	-@echo $(BLUE)CREATING DOCKER NGINX REVERSE PROXY HANDLE WITH HOSTNAME $(APP_IMAGE_NAME)
	@if [ ! -f $(DEFF_MAKER)docker/$(APP_IMAGE_NAME).conf ]; then \
		read -p "Do you want to create the Docker Nginx configuration for $(APP_IMAGE_NAME)? (y/n): " answer; \
		if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
			bash $(SCRIPT_DOCKER_NGINX) $(APP_IMAGE_NAME); \
		else \
			echo $(YELLOW)"Skipping Docker Nginx configuration creation."; \
		fi \
	else \
		echo $(YELLOW)"DOCKER NGINX REVERSE PROXY WITH NAME $(APP_IMAGE_NAME).conf EXIST"; \
	fi


delete_docker_nginx: ##DELETE THE NGINX REVERSE PROXY FOR THIS APP
	@echo $(RED)DELETE DOCKER NGINX CONF WITH NAME $(APP_IMAGE_NAME).conf
	@if [ -f $(DEFF_MAKER)docker/$(APP_IMAGE_NAME).conf ]; then \
		read -p "Do you want to delete the Docker Nginx configuration for $(APP_IMAGE_NAME)? (y/n): " answer; \
		if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
			rm -rf $(DEFF_MAKER)docker/$(APP_IMAGE_NAME).conf; \
			echo $(RED)DOCKER NGINX CONF WAS DELETED WITH NAME $(APP_IMAGE_NAME).conf; \
		else \
			echo $(YELLOW)"Skipping Docker Nginx configuration deletion."; \
		fi \
	else \
		echo $(YELLOW)"DOCKER NGINX REVERSE PROXY WITH NAME $(APP_IMAGE_NAME).conf DOES NOT EXIST"; \
	fi

stop: ## Stop all or c=<name> containers
	@if [ ! -f $(DOCKER_COMPOSE_FILE) ]; then \
		echo $(RED)"DOCKER_COMPOSE_FILE not found"; \
	else \
		$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) stop $(c); \
	fi

rebuild: ## Rebuild all or c=<name> containers in foreground
	@if [ ! -f $(DOCKER_COMPOSE_FILE) ]; then \
		echo $(RED)"DOCKER_COMPOSE_FILE not found"; \
	else \
		$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up -d --build $(c); \
	fi

restart: ## Restart all or c=<name> containers
	@if [ ! -f $(DOCKER_COMPOSE_FILE) ]; then \
		echo $(RED)"DOCKER_COMPOSE_FILE not found"; \
	else \
		$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) stop $(c); \
		$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up $(c) -d; \
	fi

status: ## Show status of containers
	@if [ ! -f $(DOCKER_COMPOSE_FILE) ]; then \
		echo $(RED)"DOCKER_COMPOSE_FILE not found"; \
	else \
		$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) ps; \
	fi

up: ## Start all or c=<name> containers in foreground
	@if [ ! -f $(DOCKER_COMPOSE_FILE) ]; then \
		echo $(RED)"DOCKER_COMPOSE_FILE not found"; \
	else \
		$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up $(c); \
	fi

start: ## Start all or c=<name> containers in background
	@if [ ! -f $(DOCKER_COMPOSE_FILE) ]; then \
		echo $(RED)"DOCKER_COMPOSE_FILE not found"; \
	else \
		$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up -d $(c); \
	fi


logs: ## Show logs for all or c=<name> containers
	@if [ ! -f $(DOCKER_COMPOSE_FILE) ]; then \
		echo $(RED)"DOCKER_COMPOSE_FILE not found"; \
	else \
		$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) logs --tail=100 -f $(c); \
	fi

clean: choose_context ## Clean all data
	@if [ ! -f $(DOCKER_COMPOSE_FILE) ]; then \
		echo $(RED)"DOCKER_COMPOSE_FILE not found"; \
	else \
		read -p "Are you sure you want to clean all data? [y/N]: " answer; \
		if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
			$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) down; \
		else \
			echo "Aborted."; \
		fi \
	fi


clean_volumes: choose_context## Clean Docker created volumes by this app
	@docker volume rm -f $$(docker volume ls | grep $(APP_NAME))

app_command: choose_context## Docker exec in app image commands
	@docker exec -it $(APP_IMAGE_NAME) $(dc)

container_info: change_context ## GET the info about countainer or all runned container c=<name> containers or id
	@bash $(SCRIPT_DOCKER_CONTAINER_INFO) $(c)

#DOCKER COMMANDS END


#DOCKER REGISTRY START

setup_registry: ## Set up a private Docker registry on the server
	@ssh $(SSH_SERVER) "docker run -d -p 5000:5000 --restart=always --name registry registry:2"

delete_registry: ## Delete registry in server
	@ssh $(SSH_SERVER) "docker rm -f registry"

push_image: ## Push image to remote Docker registry via SSH tunnel
	# Open SSH tunnel to remote host, with a socket name so that we can close it later
	@ssh -M -S $(SOCKET_NAME) -fnNT -L 5000:$(REMOTE_HOST):5000 $(SSH_SERVER)

	@if [ $$? -eq 0 ]; then \
		echo $(GREEN)"SSH tunnel established, we can push image"; \
		docker push localhost:5000/$(IMAGE); \
		ssh -S $(SOCKET_NAME) -O exit $(SSH_SERVER); \
		echo $(RED)"SSH tunnel closed"; \
	else \
		echo $(RED)"Failed to establish SSH tunnel"; \
	fi

pull_image: ## Pull image from remote Docker registry via SSH tunnel
	# Open SSH tunnel to remote host, with a socket name so that we can close it later
	@ssh -M -S $(SOCKET_NAME) -fnNT -L 5000:$(REMOTE_HOST):5000 $(SSH_SERVER)

	@if [ $$? -eq 0 ]; then \
		echo $(GREEN)"SSH tunnel established, we can pull image"; \
		docker pull localhost:5000/$(IMAGE); \
		ssh -S $(SOCKET_NAME) -O exit $(SSH_SERVER); \
		echo $(RED)"SSH tunnel closed"; \
	else \
		echo $(RED)"Failed to establish SSH tunnel"; \
	fi

#DOCKER REGISTRY END


#DIGITALOCEAN CLI START

install_doctl: ## Install DigitalOcean cli to local server
	@bash $(SCRIPT_DO_CHECK_CLI_INSTALL)

create_ssh_key: ## Create ssh key for server access with path
	@if [ -f "$(SSH_KEY_FILE)" ]; then \
		read -p "SSH key already exists. Do you want to create a new key? (y/n): " answer; \
	else \
		answer="y"; \
	fi; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		ssh-keygen -t rsa -b 4096 -C "$(SSH_KEY_COMMENT)" -f "$(SSH_KEY_FILE)"; \
	else \
		echo $(YELLOW)"Skipping SSH key creation."; \
	fi

add_ssh_key: ## Add the public key to the remote server's authorized_keys
	@ssh-copy-id -i $(SSH_KEY_FILE).pub $(REMOTE_USER)@$(IP)

create_droplet: create_ssh_key ## Create DigitalOcean droplet and get the ip address
	$(eval IP := $(shell $(SCRIPT_DO_DROPLET) $(SSH_KEY_NAME) $(SSH_KEY_FILE) $(APP_NAME))) 
	@echo $(GREEN)"Droplet created with IP: $(IP)"
	@bash $(SCRIPT_DO_DOCKER_INSTALL) $(IP)

delete_droplet: ## DELETE DigitalOcean droplet by droplet name
	@read -p "Are you sure you want to delete the droplet for $(APP_NAME)? [y/N]: " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		bash $(SCRIPT_DO_DROPLET_DELETE) $(APP_NAME); \
	else \
		echo $(YELLOW)"Aborted deleting droplet."; \
	fi


#DIGITALOCEAN CLI END

