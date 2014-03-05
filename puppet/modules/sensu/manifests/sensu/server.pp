class sensu::sensu::server {
	File{
		require => Class['sensu::sensu::install'],
		owner   => "sensu",
		group   => "sensu"
	}


  define sensu_check_alert($handler_name,
										 $check_command,
										 $check_interval,
										 $subscription_channels){
			file {"/etc/sensu/conf.d/${name}.json":
		    content => template("sensu/sensu/check_alert.json.erb")
	    }
	}

  define sensu_check_metric($handler_name,
										 $check_command,
										 $check_interval,
										 $subscription_channels){
			file {"/etc/sensu/conf.d/${name}.json":
		    content => template("sensu/sensu/check_metric.json.erb")
	    }
	}

  # $pagerduty_api_key     = extlookup("pagerduty_api_key")
  # $graphite_host         = extlookup("graphite_host")
  # $graphite_port         = extlookup("graphite_port")
  # $smtp_address          = extlookup("smtp_address")
  # $smtp_port             = extlookup("smtp_port")
  # $smtp_username         = extlookup("smtp_username")
  # $smtp_password         = extlookup("smtp_password")

	sensu_check_alert{"check_cron":
		handler_name          => "default\", \"pagerduty\", \"mailer",
		check_command         => "/etc/sensu/plugins/check-procs.rb -p crond -C 1 ",
		check_interval        => "60",
		subscription_channels => '"analytics"',
	}

	sensu_check_alert{'check-cpu':
		handler_name          => "default\", \"pagerduty\", \"mailer",
		check_command         => "/etc/sensu/plugins/check-cpu.sh -i 45 -w 60 -c 80",
		check_interval        => "60",
		subscription_channels => '"all"',
	}

  sensu_check_alert{'check-mem':
		handler_name          => "default\", \"pagerduty\", \"mailer",
		check_command         => "/etc/sensu/plugins/check-mem.sh -p -w 600 -c 400",
		check_interval        => "60",
		subscription_channels => '"all"',
	}

  sensu_check_alert{'check-disk':
		handler_name          => "default\", \"pagerduty\", \"mailer",
		check_command         => "/etc/sensu/plugins/check-disk.sh -d / -w 85 -c 90",
		check_interval        => "60",
		subscription_channels => '"all"',
	}

  sensu_check_alert{'check-swap':
		handler_name          => "default\", \"pagerduty\", \"mailer",
		check_command         => "/etc/sensu/plugins/check-swap.sh -w 85 -c 90",
		check_interval        => "60",
		subscription_channels => '"all"',
	}

  sensu_check_alert{'cpu-metrics':
		handler_name          => "graphite",
		check_command         => "/etc/sensu/plugins/cpu-metrics.rb -s init.$::init_role.$::hostname.cpu",
		check_interval        => "60",
		subscription_channels => '"all"',
	}

  sensu_check_metric{'cpu-usage-metrics':
		handler_name          => "graphite",
		check_command         => "/etc/sensu/plugins/cpu-usage-metrics.sh -s init.$::init_role.$::hostname",
		check_interval        => "60",
		subscription_channels => '"all"',
	}
  
  sensu_check_metric{'disk-capacity-metrics':
		handler_name          => "graphite",
		check_command         => "/etc/sensu/plugins/disk-capacity-metrics.rb -s init.$::init_role.$::hostname",
		check_interval        => "60",
		subscription_channels => '"all"',
	}

  sensu_check_metric{'disk-metrics':
		handler_name          => "graphite",
		check_command         => "/etc/sensu/plugins/disk-metrics.rb -s init.$::init_role.$::hostname.disk",
		check_interval        => "60",
		subscription_channels => '"all"',
	}

  sensu_check_metric{'memory-metrics':
		handler_name          => "graphite",
		check_command         => "/etc/sensu/plugins/memory-metrics.rb -s init.$::init_role.$::hostname.memory",
		check_interval        => "60",
		subscription_channels => '"all"',
	}

  sensu_check_metric{'vmstat-metrics':
		handler_name          => "graphite",
		check_command         => "/etc/sensu/plugins/vmstat-metrics.rb -s init.$::init_role.$::hostname.vmstat",
		check_interval        => "60",
		subscription_channels => '"all"',
	}


  sensu_check_metric{'iostat-extended-metrics':
		handler_name          => "graphite",
		check_command         => "/etc/sensu/plugins/iostat-extended-metrics.rb -s init.$::init_role.$::hostname",
		check_interval        => "60",
		subscription_channels => '"all"',
	}

  file {'/etc/sensu/conf.d/pagerduty.json':
    content  => template('sensu/sensu/handlers/notification/pagerduty.json')
  }

  file {'/etc/sensu/handlers/pagerduty.rb':
    source  => "puppet:///modules/sensu/sensu/handlers/notification/pagerduty.rb"
  }

  file {'/etc/sensu/conf.d/handler_pagerduty.json':
    source => "puppet:///modules/sensu/sensu/handlers/notification/handler_pagerduty.json"
  }

  file {'/etc/sensu/conf.d/mailer.json':
    content  => template('sensu/sensu/handlers/notification/mailer.json.erb')
  }

  file {'/etc/sensu/handlers/mailer.rb':
    source  => "puppet:///modules/sensu/sensu/handlers/notification/mailer.rb"
  }

  file {'/etc/sensu/conf.d/handler_mailer.json':
    source => "puppet:///modules/sensu/sensu/handlers/notification/handler_mailer.json"
  }
  file {'/etc/sensu/conf.d/graphite.json':
    content => template('sensu/sensu/handlers/metrics/graphite.json.erb')
  }

  file {'/etc/sensu/handlers/graphite-tcp.rb':
    source => "puppet:///modules/sensu/sensu/handlers/metrics/graphite-tcp.rb"
  }

  file {'/etc/sensu/conf.d/handler_graphite.json':
    source => "puppet:///modules/sensu/sensu/handlers/notification/handler_graphite.json"
  }
}
