class sensu::sensu::configure {

	File{
		require => Class['sensu::sensu::install'],
		owner   => "sensu",
		group   => "sensu"
	}

	include client
	include server

	file {'/etc/sensu/config.json':
		content => template("sensu/sensu/config.json.erb")
	}

	file {'/etc/sensu/ssl/':
		ensure => directory;
	}

	file {'/etc/sensu/ssl/client_key.pem':
		source  => "puppet:///modules/sensu/sensu/client_key.pem",
		mode    => 600,
		require => File['/etc/sensu/ssl/'];
	}

	file {'/etc/sensu/ssl/client_cert.pem':
		source    => "puppet:///modules/sensu/sensu/client_cert.pem",
		mode      => 600,
    require => File['/etc/sensu/ssl/'];
	}
	

}

