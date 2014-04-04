name             'myface'
maintainer       'YOUR_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures myface'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'jetty'
depends 'curl'
depends 'python'
# depends 'aws-cli'
depends 's3_file'
depends 'chef-android-sdk'