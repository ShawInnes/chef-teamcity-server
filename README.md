# teamcity-server cookbook

Installs and configures a TeamCity Server for 'production purposes' with a:
* Database (PostgreSQL)
* Git VCS support

Tested on Ubuntu 12.04 x86_64.

# Usage

Unfortunately, some manual steps are required to configure the TeamCity server:

1. Install default recipe
2. Open http://node-name:8111
3. Proceed with TeamCity initialization
4. Restart the TeamCity server

```
kill -9 $(ps aux | grep 'java' | grep -v 'grep' | awk '{print $2}')
```

5. Reopen http://node-name:8111
6. Follow instructions to re-create database

Logs can be found in /opt/TeamCity/logs

# Attributes

```ruby
default["teamcity-server"]["version"] = "7.1.5"
default["teamcity-server"]["postgresql"]["version"] = "9.2"
default["teamcity-server"]["postgresql"]["driver_version"] = "9.2-1002"
default["teamcity-server"]["postgresql"]["locale"] = "en_AU.UTF8"
default["teamcity-server"]["git"]["version"] = "1.8.3"
```

# Recipes

* __default__: Installs Oracle Java, TeamCity Server, PostgreSQL and Git.  Partially configures the TeamCity Server.

# Author

Author:: Matthew Ueckerman

Organisation:: MYOB
