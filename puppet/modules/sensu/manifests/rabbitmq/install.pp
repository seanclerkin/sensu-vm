class sensu::rabbitmq::install {
	package {'http://www.rabbitmq.com/releases/rabbitmq-server/v3.2.4/rabbitmq-server-3.2.4-1.noarch.rpm':
		ensure => present;
	}
}