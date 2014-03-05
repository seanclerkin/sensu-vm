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

}
