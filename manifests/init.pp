class nodejs($node_ver = 'v0.6.17') {

  $node_tar = "node-$node_ver.tar.gz"
  $node_unpacked = "node-$node_ver"

  if defined(Package['openssl']) == false {
    package { "openssl":
      ensure => "installed"
    }
  }

  if defined(Package['libcurl4-openssl-dev']) == false {
    package { "libcurl4-openssl-dev":
      ensure => "installed"
    }
  }

  if defined(Package['curl']) == false {
    package { "curl":
      ensure => "installed"
    }
  }

  if defined(Package['build-essential']) == false {
    package { "build-essential":
      ensure => "installed"
    }
  }

  exec { 'download_node':
      command     => "curl -o $node_tar http://nodejs.org/dist/${node_ver}/${node_tar}"
    , cwd         => '/tmp'
    , path        => ['/usr/bin/', '/bin/']
    , creates     => "/tmp/${node_tar}"
    , require     => Package["curl"]
    , unless    => "which node && test `node -v` = ${node_ver}"
  }

  exec { 'extract_node':
      command     => "tar -oxzf $node_tar"
    , cwd         => '/tmp'
    , require     => Exec['download_node']
    , creates     => "/tmp/${node_unpacked}"
    , path        => ['/usr/bin/', '/bin/']
  }

  exec { 'configure_node':
      command     => "/bin/sh -c './configure'"
    , cwd         => "/tmp/${node_unpacked}"
    , require     => [ Exec["extract_node"]
                     , Package['openssl']
                     , Package["build-essential"]
                     , Package['libcurl4-openssl-dev'] ]
    , timeout     => 0
    , path        => ['/usr/bin/', '/bin/']
  }

  exec { 'make_node': 
      command     => 'make'
    , cwd         => "/tmp/${node_unpacked}"
    , require     => Exec['configure_node']
    , timeout     => 0
    , path        => ['/usr/bin/', '/bin/']
  }

  exec { 'install_node':
      command   => 'make install'
    , cwd       => "/tmp/${node_unpacked}"
    , require   => Exec['make_node']
    , timeout   => 0
    , creates   => '/usr/local/bin/node'
    , path      => ['/usr/bin/', '/bin/']
    , unless    => "which node && test `node -v` = ${node_ver}"
  }
}
