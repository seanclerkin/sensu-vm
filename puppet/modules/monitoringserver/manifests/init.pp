# Class: monitoringserver
#
#
class monitoringserver {
  contain epel
  contain sensu
  contain firewall

  Class['firewall'] ->
  Class['epel'] ->
  Class['sensu']

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
 
  package { "nagios-plugins-all":
    ensure => installed,
  }

}