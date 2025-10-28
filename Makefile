DB_USER = postgres
DB_PASSWORD = secret
DB_NAME = simple_bank
DB_HOST = localhost
DB_PORT ?= 5433  # Default for mylocal;

DB_URL = postgresql://$(DB_USER):$(DB_PASSWORD)@$(DB_HOST):$(DB_PORT)/$(DB_NAME)?sslmode=disable

postgres:
	docker run --name postgres -e POSTGRES_PASSWORD=$(DB_PASSWORD) -p 5433:5432 -d postgres

createdb:
	docker exec -it postgres createdb --username=$(DB_USER) --owner=$(DB_USER) $(DB_NAME)

dropdb:
	docker exec -it postgres dropdb --username=$(DB_USER) $(DB_NAME)

migrateup:
	migrate -path db/migration -database "$(DB_URL)" -verbose up

migratedown:
	migrate -path db/migration -database "$(DB_URL)" -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

.PHONY: createdb postgres dropdb migrateup migratedown test