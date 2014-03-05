class sensu::sensu::serviceclient {
	service {'sensu-client':
		ensure    => running,
		enable    => true,
		require   => Class['sensu::sensu::configure'];
	}
}

