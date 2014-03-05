# Class: monitoringserver
#
#
class monitoringserver {
  contain epel
  contain firewall
  contain sensu::redis
  contain sensu::rabbitmq
  contain sensu::sensuserver
  contain sensu::sensuclient
  
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

  Class['firewall'] ->
  Class['epel'] ->
  Class['sensu::redis'] -> 
  Class['sensu::rabbitmq'] -> 
  Class['sensu::sensuserver'] -> 
  Class['sensu::sensuclient']

  Firewall {
    before  => Class['my_fw::post'],
    require => Class['my_fw::pre'],
  }

  class { ['my_fw::pre', 'my_fw::post']: }

  firewall { '100 allow 8080 access':
    port   => [8080],
    proto  => tcp,
    action => accept,
  }

  firewall { '101 allow 15672 access':
    port   => [15672],
    proto  => tcp,
    action => accept,
  }

  firewall { '101 allow 55672 access':
    port   => [55672],
    proto  => tcp,
    action => accept,
  }
 
  package { "nagios-plugins-all":
    ensure => installed,
  }

}