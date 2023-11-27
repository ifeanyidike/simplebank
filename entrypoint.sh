#!/bin/sh

# Function to wait for PostgreSQL
source /app/app.env

wait_for_postgres() {
  until nc -z -w 5 $POSTGRES_HOST $POSTGRES_PORT; do
    echo "Waiting for PostgreSQL to become available at $POSTGRES_HOST:$POSTGRES_PORT..."
    sleep 10
  done
}

# Debugging: Print the current time before waiting for PostgreSQL
echo "Before waiting for PostgreSQL: $(date)"

# Wait for PostgreSQL
wait_for_postgres

# Debugging: Print the current time after waiting for PostgreSQL
echo "After waiting for PostgreSQL: $(date)"

# Run the migration
./migrate -path db/migration -database "$DB_SOURCE" -verbose up

# Check the exit status of the migration command
if [ $? -eq 0 ]; then
  echo "Migration successful!"
else
  echo "Migration failed. Exiting."
  exit 1
fi

# Run the main application
./main
