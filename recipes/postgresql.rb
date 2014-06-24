# Configure locale, user and database
postgres_version = node["teamcity-server"]["postgresql"]["version"]
postgres_locale = node["teamcity-server"]["postgresql"]["locale"]
node.default["postgresql"]["version"] = postgres_version

# File locations - version specific
node.default["postgresql"]["data_directory"] = "/var/lib/postgresql/#{postgres_version}/main"
node.default["postgresql"]["hba_file"] = "/etc/postgresql/#{postgres_version}/main/pg_hba.conf"
node.default["postgresql"]["ident_file"] = "/etc/postgresql/#{postgres_version}/main/pg_ident.conf"
node.default["postgresql"]["external_pid_file"] = "/var/run/postgresql/#{postgres_version}-main.pid"

# Socket directory - version specific
if Gem::Version.new(postgres_version) >= Gem::Version.new("9.3")
  node.default["postgresql"]["unix_socket_directories"] = "/var/run/postgresql"
else
  node.default["postgresql"]["unix_socket_directory"] = "/var/run/postgresql"
end

# Locale settings
node.default["postgresql"]["initdb_options"] = "--locale=#{postgres_locale}"
node.default["postgresql"]["lc_messages"] = postgres_locale
node.default["postgresql"]["lc_monetary"] = postgres_locale
node.default["postgresql"]["lc_numeric"] = postgres_locale
node.default["postgresql"]["lc_time"] = postgres_locale

# Database to create
node.default["postgresql"]["databases"] = [
  {
    "name" => "teamcity",
    "owner" => "teamcity",
    "template" => "template0",
    "encoding" => "utf8",
    "locale" => postgres_locale,
  }
]

execute "add-locale" do
  command "locale-gen #{postgres_locale}"
end

include_recipe "postgresql::server"
