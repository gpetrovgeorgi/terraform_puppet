class profile::user (
  Hash $users,
){
  user { $users['name']:
    ensure   => $users['ensure'],
    home     => $users['home_dir'],
    uid      => $users['uid'],
    groups   => $users['group'],
    password => $users['password'],
  }
  file { $users['sudo_file']:            
    ensure  => present,
    content => $users['sudoers_content'], 
    require => User[$users['name']],
  }
  file { [$users['home_dir'], $users['key_dir']]:
    ensure => directory,
    owner  => '$users['name'],
    group  => '$users['name'],
    mode   => '0600',
  }
}
