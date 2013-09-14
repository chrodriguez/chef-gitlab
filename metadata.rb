name             'gitlab'
maintainer       'CeSPI - UNLP'
maintainer_email 'car@cespi.unlp.edu.ar'
license          'MIT'
description      'Installs/Configures gitlab'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends          'apt', "~> 1.10.0"
depends          'mysql', "~> 3.0.4"
depends          'database', "~> 1.4.0"
