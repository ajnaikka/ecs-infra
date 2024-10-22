#!/bin/bash
apt-get update
apt-get install -y postgresql-client
 
#!/bin/bash
 
ENDPOINT="odoo-prod-postgresqlv2-one.csr6co9ooj5v.ap-south-1.rds.amazonaws.com"
PGPASS="-C0pk.p.BWw*9{?kiv|EgKQy2Z1w"
ODOOPASS="A%j+u&T4Dz8v<Okk"
 
export PGPASSWORD=$PGPASS
 
psql --host=$ENDPOINT --username=postgres --dbname=postgres -c "CREATE USER odoo WITH PASSWORD '$ODOOPASS';"
psql --host=$ENDPOINT --username=postgres --dbname=postgres -c "ALTER USER odoo WITH CREATEDB;"
psql --host=$ENDPOINT --username=postgres --dbname=postgres -c "CREATE DATABASE odoo;"
