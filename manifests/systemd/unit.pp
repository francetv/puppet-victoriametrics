define victoriametrics::systemd::unit (
  Enum['present', 'absent', 'file']        $ensure                   = 'present',
  Stdlib::Absolutepath                     $path                     = '/etc/systemd/system',
  Optional[Hash]                           $settings                 = undef,
  String                                   $owner                    = 'root',
  String                                   $group                    = 'root',
  String                                   $mode                     = '0444',
  Boolean                                  $show_diff                = true,
  Optional[Variant[Boolean, Enum['mask']]] $enable                   = undef,
  Optional[Boolean]                        $active                   = undef,
  Optional[Boolean]                        $sort_settings_alphabetic = undef,
  Optional[String]                         $restart                  = undef,
  Optional[String]                         $type                     = undef,
) {
  $_sort_settings_alphabetic = pick($sort_settings_alphabetic, true)

  datacat_fragment { "sytemd_${name}":
    target => "${path}/${name}.service",
    data   => {
      syslog_identifier        => $name,
      sort_settings_alphabetic => $_sort_settings_alphabetic,
      settings                 => $settings
    },
  }

  datacat { "${path}/${name}.service":
    owner    => $owner,
    group    => $group,
    mode     => $mode,
    template => "${module_name}/systemd/unit.erb",
    notify   => Class['victoriametrics::systemd::reload'],
  }

  if $enable != undef or $active != undef {
    service { $name:
      ensure    => $active,
      enable    => $enable,
      restart   => $restart,
      hasstatus => true,
      provider  => 'systemd',
    }

    if $ensure == 'absent' {
      if $enable or $active {
        fail("Can't ensure the unit file is absent and activate/enable the service at the same time")
      }
      Service[$name] -> Datacat["${path}/${name}"]
    } else {
      Class['victoriametrics::systemd::reload'] -> Service[$name]
      Datacat["${path}/${name}"] ~> Service[$name]
    }
  }
}
