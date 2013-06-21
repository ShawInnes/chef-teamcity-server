# teamcity-server cookbook

Installs and configures a TeamCity server for 'production purposes' with a:
* Database (PostgreSQL)
* Git VCS support

Based on a [pre-existing TeamCity server cookbook](http://community.opscode.com/cookbooks/teamcity_server).

Tested on Ubuntu 12.04 x86_64.

# Usage

__Note__ manual steps are required to configure the TeamCity server that depend on the TeamCity version you choose to install.
Should you need them, logs can be found in /opt/TeamCity/logs.

## TeamCity 8

1. Install default recipe
2. Open the server homepage (http://configured-address:configured-port)
3. Proceed with TeamCity initialization

## TeamCity 7

1. Install default recipe
2. Open the server homepage (http://configured-address:configured-port)
3. Proceed with TeamCity initialization but do not accept license agreement
4. Restart the TeamCity server
```
sudo stop teamcity-server
# Wait until stopped
sudo start teamcity-server
```
5. Reopen the server homepage
6. Follow instructions to re-create the database

# Attributes

```ruby
default["teamcity-server"]["version"] = "8.0"
default["teamcity-server"]["address"] = "0.0.0.0"
default["teamcity-server"]["port"] = 8111
default["teamcity-server"]["postgresql"]["version"] = "9.2"
default["teamcity-server"]["postgresql"]["driver_version"] = "9.2-1002"
default["teamcity-server"]["postgresql"]["locale"] = "en_AU.UTF-8"
default["teamcity-server"]["git"]["version"] = "1.8.3"
```

# Recipes

* __default__: Installs Oracle Java, PostgreSQL, Git and the TeamCity server.
  Configures the TeamCity server and an Upstart service (teamcity-server).

# Author

Author:: Matthew Ueckerman

Organisation:: MYOB
