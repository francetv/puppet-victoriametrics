# PRIVATE CLASS: do not call directly
class victoriametrics::vminsert::service {
  $ensure = $victoriametrics::params::ensure
  $service_name = $victoriametrics::vminsert::service_name
  $user = $victoriametrics::params::user
  $group = $victoriametrics::params::group
  $configuration_file = $victoriametrics::vminsert::configuration_file
  $binary_directory = $victoriametrics::params::binary_directory
  $service_enable = $victoriametrics::vminsert::service_enable
  $service_status = $victoriametrics::vminsert::service_status
  $service_manage = $victoriametrics::vminsert::service_manage

  $service_ensure = $ensure ? {
    'present'  => true,
    default   => false
  }

  if $service_manage {
    systemd::manage_unit { "${service_name}.service":
      ensure        => $ensure,
      enable        => $service_enable,
      active        => $service_ensure,
      unit_entry    => {
        'Description' => 'VictoriaMetrics vminsert service',
        'After'       => 'network.target',
      },
      service_entry => {
        'Type'             => 'simple',
        'User'             => $user,
        'Group'            => $group,
        'UMask'            => '0002',
        'ExecStart'        => "${binary_directory['path']}/vminsert-prod -envflag.enable",
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
