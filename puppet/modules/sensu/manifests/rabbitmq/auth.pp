class sensu::rabbitmq::auth {
	Exec {
		require => Class['sensu::rabbitmq::service']
	}

	exec {'rabbitmqctl add_vhost /sensu':
	}

	exec {'rabbitmqctl add_user sensu TheSun':
		require => Exec['rabbitmqctl add_vhost /sensu'];
	}

	exec {"rabbitmqctl set_permissions -p /sensu sensu \".*\" \".*\" \".*\"":
		require => Exec['rabbitmqctl add_user sensu TheSun'];
	}
}
		
