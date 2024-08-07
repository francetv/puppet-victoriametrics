# PRIVATE CLASS: do not call directly
class victoriametrics::vmselect::service {
  $ensure = $victoriametrics::params::ensure
  $service_name = $victoriametrics::vmselect::service_name
  $user = $victoriametrics::params::user
  $group = $victoriametrics::params::group
  $configuration_file = $victoriametrics::vmselect::configuration_file
  $binary_directory = $victoriametrics::params::binary_directory
  $service_enable = $victoriametrics::vmselect::service_enable
  $service_status = $victoriametrics::vmselect::service_status
  $service_manage = $victoriametrics::vmselect::service_manage

  $service_ensure = $ensure ? {
    'present'  => true,
    default   => false
  }

  if $service_manage {
    systemd::manage_unit { "${service_name}.service":
      ensure        => $ensure,
      enable        => $service_enable,
      active        => $service_status,
      unit_entry    => {
        'Description' => 'VictoriaMetrics vmselect service',
        'After'       => 'network.target',
      },
      service_entry => {
        'Type'             => 'simple',
        'User'             => $user,
        'Group'            => $group,
        'UMask'            => '0002',
        'ExecStart'        => "${binary_directory['path']}/vmselect-prod -envflag.enable",
        'EnvironmentFile'  => $configuration_file['path'],
        'Restart'          => 'on-failure',
        'RestartSec'       => '30',
        'PrivateTmp'       => true,
        'NoNewPrivileges'  => true,
        'ProtectSystem'    => 'full',
        'SyslogIdentifier' => $service_name
      },
      install_entry => {
        'WantedBy' => 'multi-user.target',
      },
    }

    service { $service_name:
      ensure    => $service_ensure,
      name      => $service_name,
    }
  }
}
