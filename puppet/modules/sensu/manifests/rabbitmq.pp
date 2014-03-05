class sensu::rabbitmq {
	include sensu::rabbitmq::install
	include sensu::rabbitmq::configure
	include sensu::rabbitmq::service
	include sensu::rabbitmq::auth
}

