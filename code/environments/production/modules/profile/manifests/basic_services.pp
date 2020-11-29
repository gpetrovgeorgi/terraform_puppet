class profile::basic_services (
  Hash $basic_services,
  ){
#  include phpfpm

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
}
