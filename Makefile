COMPOSE_PATH		:=	srcs/compose.yml

all: up

up: build
	docker compose -f $(COMPOSE_PATH) up -d

build:
	docker compose -f $(COMPOSE_PATH) build

down:
	docker compose -f $(COMPOSE_PATH) down --volumes --remove-orphans

ps:
	docker compose -f $(COMPOSE_PATH) ps

logs:
	docker compose -f $(COMPOSE_PATH) logs

re: down up

it:
	docker exec -it nginx bash

prune:
	docker system prune -a

.PHONY: all up build down ps logs re prune