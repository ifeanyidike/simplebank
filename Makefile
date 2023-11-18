postgres:
	docker run --name postgres16 --network bank-network -p 5432:5432 -e POSTGRES_USER=ifeanyidike -e POSTGRES_PASSWORD=secret -d postgres:16-alpine

createdb:
	docker exec -it postgres16 createdb --username=ifeanyidike --owner=ifeanyidike simple_bank

dropdb:
	docker exec -it postgres16 dropdb simple_bank --username=ifeanyidike

migrateup:
	migrate -path db/migration -database "postgresql://ifeanyidike:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migrateup1:
	migrate -path db/migration -database "postgresql://ifeanyidike:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up 1

migratedown:
	migrate -path db/migration -database "postgresql://ifeanyidike:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

migratedown1:
	migrate -path db/migration -database "postgresql://ifeanyidike:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down 1

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go  github.com/ifeanyidike/simple_bank/db/sqlc Store

.PHONY:
	postgres createdb dropdb migrateup migrateup1 migratedown migratedown1 sqlc test server mock