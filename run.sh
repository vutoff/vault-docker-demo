#!/bin/bash -x
sleep 10
VAULT_RETRIES=5
echo "Vault is starting..."
until vault status > /dev/null 2>&1 || [ "$VAULT_RETRIES" -eq 0 ]; do
        echo "Waiting for vault to start...: $((VAULT_RETRIES--))"
        sleep 1
done
echo "Authenticating to vault..."
vault login token=my-very-secure-token

echo "Initializing vault..."
vault secrets enable -version=2 -path=secrets kv

echo "Adding entries..."
vault kv put secrets/dev username=test_user
vault kv put secrets/dev password=test_password

echo "Enable DB engine"
vault secrets enable database
vault write database/config/my-postgresql-database \
    plugin_name=postgresql-database-plugin \
    allowed_roles="my-role" \
    connection_url="postgresql://{{username}}:{{password}}@${DB_HOST}/?sslmode=disable" \
     username=${DB_USER} \
     password=${DB_PASS}

vault write database/roles/my-role \
  db_name=my-postgresql-database \
  creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
                      GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
  default_ttl="1h" \
  max_ttl="24h"

echo "Complete..."
