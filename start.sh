#!/bin/sh

set -e
source /app/app.env
echo "run db migration"
# /app/migrate -path /app/db/migration -database "$DB_SOURCE" -verbose up
./migrate -path db/migration -database "$DB_SOURCE" -verbose up

echo "start the app with SERVER_ADDRESS: $SERVER_ADDRESS"
exec /app/main -addr="$SERVER_ADDRESS"

# echo "start the app"
# exec "$@"
# ./main