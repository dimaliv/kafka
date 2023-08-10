target = override

override container-name-app = kafka
override docker-compose = docker compose -f docker-compose.yml -f docker-compose.$(target).yml

default: build up

# Docker

ps: FORCE ; $(docker-compose) ps
images: FORCE ; $(docker-compose) images
build: FORCE ; $(docker-compose) build --pull --progress=plain
up: FORCE ; $(docker-compose) up -d --remove-orphans --no-build
down: FORCE ; $(docker-compose) down --remove-orphans
push: FORCE ; $(docker-compose) push
pull: FORCE ; $(docker-compose) pull --ignore-pull-failures
logs: FORCE ; $(docker-compose) logs -f

# Cheat

FORCE:
