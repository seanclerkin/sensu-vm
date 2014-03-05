class sensu::sensu::serviceserver {

  Service{
		require   => Class['sensu::sensu::configure']
  }

	service {['sensu-server', 'sensu-api', 'sensu-dashboard']:
		ensure    => running,
		enable    => true
	}

  service {['sendmail']:
    ensure => running,
    enable => true
  }
}

