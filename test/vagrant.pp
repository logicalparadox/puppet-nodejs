class { 'nodejs':
  node_ver => 'v0.6.16'
}

package { 'express':
    ensure      => latest
  , provider    => 'npm'
}

nodejs::npm { '/tmp/npm::express':
    ensure      => 'present'
  , version     => 'latest'
}
