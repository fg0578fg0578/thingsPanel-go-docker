set -e
#echo "host all all 0.0.0.0/0 " >> /var/lib/postgresql/data/pg_hba.conf

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  set time zone 'Asia/Shanghai';
  \c "$POSTGRES_DB"
EOSQL
#CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;