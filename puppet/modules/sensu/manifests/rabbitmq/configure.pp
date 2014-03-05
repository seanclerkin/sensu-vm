class sensu::rabbitmq::configure {

	file {'/etc/rabbitmq/ssl/':
		ensure  => directory,
		require => Class['sensu::rabbitmq::install'];
	}

	file {'/etc/rabbitmq/ssl/server_key.pem':
		source  => 'puppet:///modules/sensu/rabbitmq/server_key.pem',
		require => File['/etc/rabbitmq/ssl/'];
	}

  file {'/etc/rabbitmq/ssl/server_cert.pem':
		source    => 'puppet:///modules/sensu/rabbitmq/server_cert.pem',
    require => File['/etc/rabbitmq/ssl/'];
	}

  file {'/etc/rabbitmq/ssl/cacert.pem':
		source    => 'puppet:///modules/sensu/rabbitmq/cacert.pem',
    require => File['/etc/rabbitmq/ssl/'];
	}

	file {'/etc/rabbitmq/rabbitmq.config':
		source => 'puppet:///modules/sensu/rabbitmq/rabbitmq.config',
    require => Class['sensu::rabbitmq::install'];
	}

	exec {'rabbitmq-plugins enable rabbitmq_management':
		environment => 'HOME=/root',
		require     => File['/etc/rabbitmq/rabbitmq.config'];
	}
}
