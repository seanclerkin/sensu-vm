class sensu::redis::service {
	service {'redis':
		enable  => true,
		ensure  => running,
		require => Class['sensu::redis::install'];
	}
}
