#!/bin/sh

set -e

echo "run db migration"
# /app/migrate -path /app/db/migration -database "$DB_SOURCE" -verbose up
./migrate -path db/migration -database "$DB_SOURCE" -verbose up

echo "start the app"
exec "$@"
# ./main