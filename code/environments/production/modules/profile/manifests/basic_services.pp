class profile::basic_services (
  Hash $basic_services,
  String $address_ipv4 = $::facts['networking']['interfaces']['eth0']['ip'],
  String $public_ipv4  = $::facts['ec2_metadata']['public-ipv4'],
  String $os_type      = $::facts['os']['name'],
  String $os_release   = $::facts['os']['release']['full'],
  Integer $num_cpus    = $::facts['processors']['count'],
  String $cpu_model    = $::facts['processors']['models'][0],
  String $mem_total    = $::facts['memory']['system']['total'],
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
    ensure  => $basic_services['phpfpm_packet_ensure'],
    require => Service[$basic_services['service_nginx']],
  }
  service { $basic_services['service_phpfpm']:
    ensure  => $basic_services['phpfpm_service_ensure'],
    enable  => $basic_services['phpfpm_enabled'],
    require => Package[$basic_services['package_phpfpm']],
  }
  file { ['/var/www', '/var/www/html']:
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
