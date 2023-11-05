postgres:
	docker run --name postgres16 -p 5432:5432 -e POSTGRES_USER=ifeanyidike -e POSTGRES_PASSWORD=secret -d postgres:16-alpine

createdb:
	docker exec -it postgres16 createdb --username=ifeanyidike --owner=ifeanyidike simple_bank

dropdb:
	docker exec -it postgres16 dropdb simple_bank --username=ifeanyidike

migrateup:
	migrate -path db/migration -database "postgresql://ifeanyidike:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://ifeanyidike:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

.PHONY:
	postgres createdb dropdb migrateup migratedown sqlc test