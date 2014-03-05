class sensu::sensu::client {
  File{
		require => Class['sensu::sensu::install'],
		owner   => "sensu",
		group   => "sensu"
	}
	$role                  = $::init_role
	$client_fqdn           = "${::fqdn}_${::init_role}"
	$client_ip             = $::ipaddress
 	file {'/etc/sensu/conf.d/client.json':
		content => template('sensu/sensu/client.json.erb')
	}

	package{'bc':
		ensure => present
	}

  file {'/etc/sensu/plugins/':
		source  => 'puppet:///modules/sensu/sensu/checks',
		recurse => true,
		mode => 755,
	}

}
