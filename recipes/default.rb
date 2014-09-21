cache_path = Chef::Config[:file_cache_path]

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

# Generate random database password (if not already set)
if Chef::Config[:solo]
  if node.teamcity["database"]["password"].nil?
    Chef::Application.fatal!(
      "You must set node['teamcity']['database']['password'] in chef-solo mode.",
    )
  end
else
  node.set_unless["teamcity"]["database"]["password"] = secure_password
  node.save
end

# Install Java
include_recipe "java"

# Install PostgreSQL
include_recipe "teamcity::postgresql"

include_recipe "git"

group node['teamcity']['group'] do
  action :create
end


user node['teamcity']['user'] do
  action :create
  comment "Team City"
  gid node['teamcity']['group']
  system true
end


# Install TeamCity Server
server_archive_name = "TeamCity-#{node["teamcity"]["version"]}.tar.gz"
server_archive_path = "#{cache_path}/#{server_archive_name}"
server_directory = "/opt/teamcity/#{node["teamcity"]["version"]}"
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
    tar -xvf #{server_archive_path} --strip 1 --owner=#{node['teamcity']['user']} --group=#{node['teamcity']['group']}
    chown -R #{node['teamcity']['user']}:#{node['teamcity']['group']} #{server_directory}
  EOH
  action :nothing
end

# Configure TeamCity Server
config_directory = "#{server_directory}/conf"
template "#{config_directory}/server.xml" do
  source "server.xml.erb"
  owner node['teamcity']['user']
  group node['teamcity']['group']
  variables(
    :address => node["teamcity"]["address"],
    :port => node["teamcity"]["port"]
  )
end

directory "#{server_directory}/logs" do
  owner node['teamcity']['user']
  group node['teamcity']['group']
  mode "0755"
  action :create
end

directory "#{server_directory}/buildAgent/logs" do
  owner node['teamcity']['user']
  group node['teamcity']['group']
  mode "0755"
  action :create
end


template "#{server_directory}/bin/teamcity-init.sh" do
  source "teamcity-init.sh.erb"
  owner node['teamcity']['user']
  group node['teamcity']['group']
  notifies :restart, "service[teamcity-server]"
end

link "/opt/teamcity/current" do
  to server_directory
  owner node['teamcity']['user']
  group node['teamcity']['group']
end

data_dir = node["teamcity"]["data_directory"]
[data_dir, "#{data_dir}/lib", "#{data_dir}/lib/jdbc"].each do |path|
  directory path do
    owner node['teamcity']['user']
    group node['teamcity']['group']
    mode "0755"
    action :create
  end
end


jdbc_driver_filename = "postgresql-#{node["teamcity"]["postgresql"]["driver_version"]}.jdbc4.jar"
jdbc_driver_directory = "#{data_dir}/lib/jdbc"
remote_file "#{jdbc_driver_directory}/#{jdbc_driver_filename}" do
  backup false
  mode 00644
  source "http://jdbc.postgresql.org/download/#{jdbc_driver_filename}"
  owner node['teamcity']['user']
  group node['teamcity']['group']
  action :create_if_missing
end

data_config_directory = "#{data_dir}/config"
directory data_config_directory do
  owner node['teamcity']['user']
  group node['teamcity']['group']
  recursive true
  action :create
end
template "#{data_config_directory}/database.properties" do
  source "database.properties.erb"
  owner node['teamcity']['user']
  group node['teamcity']['group']
  action :create
end

# Setup TeamCity Agent Service
template "/etc/init/teamcity-agent.conf" do
  owner node['teamcity']['user']
  group node['teamcity']['group']
  backup false
  source "init/teamcity-agent.conf.erb"
  action :create
end

service "teamcity-agent" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true
  action :enable
end

# Setup TeamCity Server Service
template "/etc/init/teamcity-server.conf" do
  owner node['teamcity']['user']
  group node['teamcity']['group']
  backup false
  source "init/teamcity-server.conf.erb"
  action :create
  notifies :restart, "service[teamcity-server]"
end

service "teamcity-server" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true
  action :start
  notifies :run, "execute[wait for teamcity-server]", :immediately
  retries 4
  retry_delay 30
end

execute "wait for teamcity-server" do
  command 'sleep 5'
  action :nothing
  notifies :start, "service[teamcity-agent]"
end
