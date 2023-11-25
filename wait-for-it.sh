#!/bin/sh
set -e

host="$1"
port="$2"
shift 2
cmd="$@"

until nc -z "$host" "$port"; do
  >&2 echo "Waiting for PostgreSQL to become available at $host:$port..."
  sleep 1
done

>&2 echo "PostgreSQL is up - executing command"
exec $cmd
