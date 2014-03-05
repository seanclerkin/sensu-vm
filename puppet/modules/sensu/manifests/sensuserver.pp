class sensu::sensuserver {
	include sensu::sensu::install
	include sensu::sensu::configure
	include sensu::sensu::serviceserver
}

