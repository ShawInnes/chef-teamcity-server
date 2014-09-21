
include_recipe "postgresql::server"

include_recipe "postgresql::client"
include_recipe "postgresql::ruby"
include_recipe "database"

connection_info = {
  :host     => 'localhost',
  :port     => node['postgresql']['config']['port'] || 5432,
  :username => 'postgres',
  :password => node['postgresql']['password']['postgres']
}

postgresql_database_user node['teamcity']['database']['user'] do
  connection  connection_info
  password    node['teamcity']['database']['password']
end


postgresql_database node['teamcity']['database']['name'] do
  connection  connection_info
  provider    Chef::Provider::Database::Postgresql
  action     :create
end

postgresql_database_user node['teamcity']['database']['user'] do
  connection    connection_info
  database_name node['teamcity']['database']['name']
  table         "*"
  privileges    [:all]
  host          '127.0.0.1'
  action        :grant
end


