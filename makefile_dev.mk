APP_NAME := reactappcontrol
APP_MODE := dev
APP_API_URL := https://demo.api.domain.com
REMOTE_USER := root
REMOTE_HOST := jsonsmile.com
SSH_PORT := 22
TIMEOUT := 5
APP_DOCKERFILE := ${DOCKER_FILE_DIR}/dev.Dockerfile
NGINX_DOCKERFILE := ${DOCKER_FILE_DIR}/nginx/
NGINX_DOCKERFILE_NAME := ${DOCKER_FILE_DIR}/nginx/Dockerfile
APP_COMPOSEFILE := dev.docker-compose.yml
DOCKER_APP_ENV := ${DOCKER_FILE_DIR}/.env.dev
DOCKER_CONTEXT := reactapp_demo
CONTEXT_DESCRIPTION := develop
CONTEXT_HOST := host=unix:///var/run/docker.sock 
FINAL_PORT := 3333
PORT_APP := 127.0.0.1:$(FINAL_PORT):3333
FINAL_PORT_STAGING := 5555
PORT_APP_STAGING := 127.0.0.1:$(FINAL_PORT_STAGING):5555
PORT_NGINX_FINAL := 8888
PORT_NGINX := 127.0.0.1:$(PORT_NGINX_FINAL):80
PORT_REDIS_FINAL := 7379
PORT_REDIS := 127.0.0.1:$(PORT_REDIS_FINAL):6379
PORT_MEMCACHE := 127.0.0.1:22322:11211
DOMAIN := jsonsmile.com
SUBDOMAIN_NAME := demo
SOCKET_NAME := dockerDev-tunnel-socket
REGISTRY_PORT := 5000
SSH_KEY_NAME := DO_$(APP_NAME)_SSH_Key
SSH_KEY_COMMENT := admin@$(DOMAIN)
SSH_KEY_FILE := $(DEFF_MAKER)digitalocean/id_rsa
SSH_GIT_KEY_FILE := $(DEFF_MAKER)git/id_rsa
BRANCH := develop
REPO_NAME := $(APP_NAME)
RSYNC_DESTINATION_DIR := /home/rsync_react/$(BRANCH)/$(REPO_NAME)/
REACT_COMMAND := "npm run dev"
REACT_COMMAND_STAGING := "npm run stg"
