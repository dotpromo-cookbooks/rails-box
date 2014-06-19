# Database setup
include_recipe 'openssl'
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

# Set db password if it empty
node.set_unless['dotpromo-rails-box']['db_pass'] = secure_password

# Default connection info
postgresql_connection_info = {
  host: 'localhost',
  port: node['postgresql']['config']['port'],
  username: 'postgres',
  password: node['postgresql']['password']['postgres']
}

# Create database
db_name = "#{node['dotpromo-rails-box']['app_name']}_production"
db_user = node['dotpromo-rails-box']['app_name']
postgresql_database db_name  do
  connection postgresql_connection_info
  action :create
end

# Create user
postgresql_database_user db_user do
  connection postgresql_connection_info
  password node['dotpromo-rails-box']['db_pass']
  action :create
end

# Grant privileges to user for this db
postgresql_database_user db_user do
  connection postgresql_connection_info
  database_name db_name
  privileges [:all]
  action :grant
end
