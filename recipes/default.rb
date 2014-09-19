archive_directory = Chef::Config[:file_cache_path]

# Install Java
include_recipe "java"

# Install PostgreSQL
include_recipe "teamcity-server::postgresql"

# Install Git
node.default["git"]["version"] = node["teamcity-server"]["git"]["version"]

include_recipe "git"

# Install TeamCity Server
server_archive_name = "TeamCity-#{node["teamcity-server"]["version"]}.tar.gz"
server_archive_path = "#{archive_directory}/#{server_archive_name}"
server_directory = "/opt/teamcity/#{node["teamcity-server"]["version"]}"
remote_file server_archive_path do
  backup false
  source "http://download.jetbrains.com/teamcity/#{server_archive_name}"
  action :create_if_missing
  notifies :run, "bash[install-teamcity]", :immediately
end
bash "install-teamcity" do
  code <<-EOH
    mkdir -p #{server_directory}
    cd #{server_directory}
    tar -xvf #{server_archive_path}
  EOH
  action :nothing
end

# Configure TeamCity Server
config_directory = "#{server_directory}/TeamCity/conf"
template "#{config_directory}/server.xml" do
  source "server.xml.erb"
  variables(
    :address => node["teamcity-server"]["address"],
    :port => node["teamcity-server"]["port"]
  )
end

template "#{server_directory}/bin/teamcity-init.sh" do
  source "teamcity-init.sh.erb"
end

link "/opt/teamcity/current" do
  to server_directory
end

data_directory = node["teamcity-server"]["data_directory"] 
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

data_config_directory = "#{data_directory}/config"
directory data_config_directory do
  recursive true
  action :create
end
cookbook_file "#{data_config_directory}/database.properties" do
  source "database.properties"
  action :create_if_missing
end

# Start TeamCity Service
template "/etc/init/teamcity-server.conf" do
  backup false
  source "init/teamcity-server.conf.erb"
  action :create
  notifies :start, "service[teamcity-server]", :immediately
end

service "teamcity-server" do
  provider Chef::Provider::Service::Upstart
  action :restart
end
