class sensu::rabbitmq::install {
	exec { "wget_rabbitmq_rpm":
    command => "wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.2.4/rabbitmq-server-3.2.4-1.noarch.rpm && yum -y install rabbitmq-server-3.2.4-1.noarch.rpm",
    path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
    cwd => "/tmp"
  }
}