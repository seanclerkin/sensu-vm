class sensu::rabbitmq::service {
	service {'rabbitmq-server':
		enable    => "true",
		ensure    => running,
		subscribe => Class['sensu::rabbitmq::configure'],
		require   => Class['sensu::rabbitmq::configure'];
	}
}

