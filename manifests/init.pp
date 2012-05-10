class nodejs($node_ver = 'v0.6.17') {

  $node_tar = "node-$node_ver.tar.gz"

  package { "openssl":
    ensure => "installed"
  }

  package { "libcurl4-openssl-dev":
    ensure => "installed"
  }

  exec { 'download_node':
      command   => "curl -o $node_tar http://nodejs.org/dist/${node_ver}/${node_tar}"
    , unless    => 'which node'
    , cwd       => '/tmp'
    , creates   => "/tmp/${node_tar}"
    , path      => ['/usr/bin/', '/bin/']
  }

  exec { 'extract_node':
      command   => "tar -xzf $node_tar"
    , cwd       => '/tmp'
    , creates   => "/tmp/node-${node_ver}"
    , require   => Exec['download_node']
    , path      => ['/usr/bin/', '/bin/']
  }

  file { "/tmp/node-${node_ver}":
      ensure    => 'directory'
    , require   => Exec['extract_node']
  }

  exec { 'configure_node':
      command   => 'bash ./configure'
    , cwd       => "/tmp/node-${node_ver}"
    , require   => [ File["/tmp/node-${node_ver}"]
                   , Package['openssl']
                   , Package['libcurl4-openssl-dev'] ]
    , timeout   => 0
    , creates   => "/tmp/node-${node_ver}/.lock_wscript"
    , path      => ['/usr/bin/', '/bin/']
  }

  exec { 'make_node': 
      command   => 'make'
    , cwd       => "/tmp/node-${node_ver}"
    , require   => Exec['configure_node']
    , timeout   => 0
    , creates   => "/tmp/node-${node_ver}/tools/js2c.pyc"
    , path      => ['/usr/bin/', '/bin/']
  }

  exec { 'install_node':
      command   => 'make install'
    , cwd       => "/tmp/node-${node_ver}"
    , require   => Exec['make_node']
    , timeout   => 0
    , creates   => '/usr/local/bin/node'
    , path      => ['/usr/bin/', '/bin/']
  }

}
