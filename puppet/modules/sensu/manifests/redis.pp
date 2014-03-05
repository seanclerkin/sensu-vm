class sensu::redis {
	include sensu::redis::install
	include sensu::redis::service
}

