# Demo Vault Dynamic Secrets with PostgreSQL DB

## Requirements
- Docker engine

## Running the demo

- Bring up the services
```sh
docker-compose up -d
```

- Authenticate to the Vault server
The root token is `my-very-secure-token`. Invoke

```sh
vault login
```
and enter the token. You should see something similar to

```sh
❯ vault login
Token (will be hidden):
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                  Value
---                  -----
token                my-very-secure-token
token_accessor       Z1bCSbdcB2hpBVNKqPBMgTLm
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]
```

### Dynamic secrets
- Obtain temporary DB credentials
```sh
vault read database/creds/my-role
```
You should see something similar to

```sh
❯ vault read database/creds/my-role
Key                Value
---                -----
lease_id           database/creds/my-role/35T7z6wxQrDI9vxt6RCqyuxj
lease_duration     1h
lease_renewable    true
password           Pp3II5kyP-pH6plI0Vm3
username           v-token-my-role-3WeK7qYp0cXt9D8L12zF-1673199871
```

Use the generated credentials to connect to the PostgreSQL server

```sh
psql -h localhost -U <username> postgres
```

Example:
```sh
❯ psql -h localhost -U v-token-my-role-vcdtHQwytCvVR6yk6zgW-1673200121 postgres
Password for user v-token-my-role-vcdtHQwytCvVR6yk6zgW-1673200121:
psql (14.6 (Homebrew))
Type "help" for help.

postgres=> \dt
Did not find any relations.
postgres=> \q
```

### Static secrets
```sh
vault kv get my.secrets/dev
```
