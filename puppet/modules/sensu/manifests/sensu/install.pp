class sensu::sensu::install {
  yumrepo { "sensu-main":
    baseurl => "http://repos.sensuapp.org/yum/el/\$releasever/\$basearch/",
    descr => "sensu-main",
    enabled => 1,
    gpgcheck => 0
  }

  package { "sensu":
    ensure => installed,
    require => Yumrepo["sensu-main"]
  }

  package { "ruby-devel":
    ensure => installed,
  }
      
  package { "rubygems":
    ensure  => installed,
    require => Package["ruby-devel"],
  }

  exec { "install_sensu-plugin_gem_${name}":
    command     => "su - root -c \"gem install --no-rdoc --no-ri sensu-plugin\"",
    unless      => "gem list | grep sensu-plugin",
    provider    => shell,
    logoutput   => true,
    require     => Package["rubygems"],
  }

}
