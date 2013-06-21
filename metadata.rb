name             "teamcity-server"
maintainer       "Matthew Ueckerman"
maintainer_email "matthew.ueckerman@myob.com"
license          "All rights reserved"
description      "Installs/Configures a TeamCity Server for production use"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.3"

depends "java", "~> 1.11.4"
depends "git", "~> 2.5.2"
depends "postgresql", "~> 0.10.1"
