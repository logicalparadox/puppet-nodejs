class { 'nodejs':
  node_ver => 'v0.6.16'
}

package { 'express':
    ensure      => '2.5.8'
  , provider    => 'npm'
}

nodejs::npm { '/tmp/npm::express':
    ensure      => 'present'
  , version     => 'latest'
}
