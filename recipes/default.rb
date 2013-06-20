# Install java
include_recipe "java"

# Install Git
include_recipe "git"

# Install TeamCity Server
include_recipe "teamcity_server::server"

# Install PostgreSQL, including locale, user and database
execute "add-locale" do
  command "locale-gen #{node["teamcity-server"]["postgresql"]["locale"]}"
end
include_recipe "postgresql::server"

# Configure TeamCity Server
data_directory = "/root/.BuildServer"

jdbc_driver_filename = "postgresql-#{node["teamcity-server"]["postgresql"]["driver_version"]}.jdbc4.jar"
jdbc_driver_directory = "#{data_directory}/lib/jdbc"

directory jdbc_driver_directory do
  recursive true
  action :create
end

remote_file "#{jdbc_driver_directory}/#{jdbc_driver_filename}" do
  backup false
  mode 00644
  source "http://jdbc.postgresql.org/download/#{jdbc_driver_filename}"
  action :create_if_missing
end

config_directory = "#{data_directory}/config"

directory config_directory do
  recursive true
  action :create
end

template "#{config_directory}/database.properties" do
  source "database.properties"
  action :create
end

bluepill_service "teamcity-server" do
  action :restart
end
