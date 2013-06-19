# teamcity-server cookbook

Installs and configures a TeamCity Server for 'production use' with a:
* Database (PostgreSQL)
* Git VCS support

Tested on Ubuntu 12.04 x86_64.

# Requirements

# Usage

1. Install default recipe
2. Open http://<node>:8111
3. Proceed with TeamCity initialization
4. Create administrator account by logging-in

TeamCity logs can be found in /opt/TeamCity/logs.

# Attributes

```ruby
default["teamcity-server"]["version"] = "7.1.5"
default["teamcity-server"]["postgresql"]["version"] = "9.2"
default["teamcity-server"]["postgresql"]["driver_version"] = "9.2-1002"
default["teamcity-server"]["postgresql"]["locale"] = "en_AU.UTF8"
default["teamcity-server"]["git"]["version"] = "1.8.3"
```

# Recipes

* __default__: Installs Oracle Java, TeamCity Server, PostgreSQL and Git.  Configures the TeamCity Server to use the
PostgreSQL database.

# Author

Author:: Matthew Ueckerman
Organisation:: MYOB
