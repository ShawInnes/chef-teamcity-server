override["postgresql"]["version"] = default["teamcity-server"]["postgresql"]["version"]
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
