override["postgresql"]["version"] = default["teamcity-server"]["postgresql"]["version"]
override["postgresql"]["initdb_options"] = "--locale=#{default["teamcity-server"]["postgresql"]["locale"]}"
override["postgresql"]["lc_messages"] = default["teamcity-server"]["postgresql"]["locale"]
override["postgresql"]["lc_monetary"] = default["teamcity-server"]["postgresql"]["locale"]
default["postgresql"]["lc_numeric"] = default["teamcity-server"]["postgresql"]["locale"]
default["postgresql"]["lc_time"] = default["teamcity-server"]["postgresql"]["locale"]
override["postgresql"]["users"] = [
  {
    "username" => "teamcity",
    "password" => "teamcity",
    "superuser" => "false",
    "createdb" => "true",
    "login" => "true"
  }
]
override["postgresql"]["databases"] = [
  {
    "name" => "teamcity",
    "owner" => "teamcity",
    "template" => "template0",
    "encoding" => "utf8",
    "locale" => default["teamcity-server"]["postgresql"]["locale"],
  }
]
