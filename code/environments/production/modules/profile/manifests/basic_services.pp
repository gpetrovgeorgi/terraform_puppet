class profile::basic_services (
  Hash $basic_services,
  ){
  exec { 'install_nginx':
    command => 'amazon-linux-extras install nginx1',
    path    => ['/usr/bin', '/usr/sbin'],
    user    => 'root',
  }
  service { $basic_services['service_nginx']:
    ensure => $basic_services['nginx_ensure'],
    enable => $basic_services['nginx_enabled'],
  }
  package { $basic_services['package_phpfpm']:
    ensure  => $basic_services['phpfpm_ensure'],
    require => Service[$basic_services['service_nginx']],
  }
  service { $basic_services['service_phpfpm']:
    ensure  => $basic_services['phpfpm_ensure'],
    enable  => $basic_services['phpfpm_enabled'],
    require => $basic_services['package_phpfpm'],
  }
  file { '/var/www/html':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
  file {'/var/www/html/index.php':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('profile/index.php.erb'),
    require => File['/var/www/html'],
  }
}
