.PHONY: up down logs pull-models update

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

# Usage: make pull-models MODEL=<model-name>
pull-models:
	@test -n "$(MODEL)" || (echo "Usage: make pull-models MODEL=<model-name>" && exit 1)
	docker compose exec ollama ollama pull $(MODEL)

update:
	docker compose pull && docker compose up -d
