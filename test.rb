require 'vault'

# Configure
Vault.configure do |config|
  config.ssl_verify = true
  config.timeout = 30
  config.ssl_timeout  = 5
  config.open_timeout = 5
  config.read_timeout = 30
end

Vault.with_retries(Vault::HTTPConnectionError, Vault::HTTPError) do |attempt, e|
  puts "Received exception #{e} from Vault - attempt #{attempt}"
  dbcreds = Vault.logical.read('database/creds/my-role')
  puts dbcreds.data # will return hash
end
