class sensu::redis::install {
	package {'redis':
		ensure => present;
	}
}

