default["teamcity"]["version"] = "8.1.4"
default["teamcity"]["address"] = "0.0.0.0"
default["teamcity"]["port"] = 8111
default["teamcity"]["postgresql"]["driver_version"] = "9.2-1002"
default["teamcity"]["data_directory"] = "/var/lib/teamcity" 

default["teamcity"]["user"] = "teamcity"
default["teamcity"]["group"] = node["teamcity"]["user"]

default["teamcity"]["database"]["name"] = "teamcity"
default["teamcity"]["database"]["user"] = "teamcity"
default["teamcity"]["database"]["password"] = nil
