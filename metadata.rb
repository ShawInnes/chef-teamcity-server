name             'teamcity'
maintainer       'Matthew Ueckerman'
maintainer_email 'matthew.ueckerman@myob.com'
license          'All rights reserved'
description      'Installs/Configures a TeamCity Server for production use'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.1'

recipe 'teamcity', 'Installs/Configures a TeamCity Server for production use'
recipe 'teamcity::postgresql', "Internal recipe to install/configure the servers database"

depends 'java', '~> 1.22.0'
depends 'git', '~> 4.0.2'
depends 'postgresql', '~> 3.4.1'
depends 'database'

supports 'ubuntu', '= 12.04'
supports 'ubuntu', '= 14.04'