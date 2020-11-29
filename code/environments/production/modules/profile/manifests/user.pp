class profile::user (
  Hash $users,
  Hash $user_access,
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
  sshkey { 'grigor':
    ensure  => present,
    key     => $user_access['user_key'],
    target  => $user_access['key_destination'],
    type    => $user_access['key_type'],
    require => File['/home/grigor/.ssh/'],
  }
}
