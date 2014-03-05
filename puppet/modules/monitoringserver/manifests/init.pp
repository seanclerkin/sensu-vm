# Class: monitoringserver
#
#
class monitoringserver {
  contain epel
  contain rabbitmq
  contain redis
  contain sensu
  contain firewall

  Class['firewall'] ->
  Class['epel'] ->
  Class['rabbitmq'] ->
  Class['redis'] ->
  Class['sensu']

  Firewall {
    before  => Class['my_fw::post'],
    require => Class['my_fw::pre'],
  }

  class { ['msm_fw::pre', 'msm_fw::post']: }

  firewall { '100 allow 8080 access':
    port   => [8080],
    proto  => tcp,
    action => accept,
  }

  rabbitmq_user { 'sensu':
    admin    => true,
    password => 'secret',
  }

  rabbitmq_vhost { 'sensu':
    ensure => present,
  }

  rabbitmq_user_permissions { 'sensu@sensu':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }


  sensu::handler { 'default':
    command => 'mail -s \'sensu alert\' ops@foo.com',
  }

  sensu::check { 'check_ntp':
    command     => 'PATH=$PATH:/usr/lib/nagios/plugins check_ntp_time -H pool.ntp.org -w 30 -c 60',
    handlers    => 'default',
    subscribers => 'sensu-test'
  }
  
  package { "nagios-plugins-all":
    ensure => installed,
  }

}