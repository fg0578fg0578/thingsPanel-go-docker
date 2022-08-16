#!/bin/sh
# wait-for-postgres.sh

set -e
  
host="$1"
password="$2"
shift
echo "----------------------------------------------------------------"
until PGPASSWORD=$password psql -h "$host" -U "postgres" -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done
  
>&2 echo "Postgres is up - executing command"
exec "$@"