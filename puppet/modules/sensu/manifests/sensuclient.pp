class sensu::sensuclient {
	include sensu::sensu::install
	include sensu::sensu::configure
	include sensu::sensu::serviceclient
}

