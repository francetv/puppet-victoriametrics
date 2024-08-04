# PRIVATE CLASS: do not call directly
class victoriametrics::vminsert::service {
  $service_ensure = $victoriametrics::params::ensure
  $service_name = $victoriametrics::vminsert::service_name
  $service_manage = $victoriametrics::vminsert::service_manage
  $user = $victoriametrics::params::user
  $group = $victoriametrics::params::group
  $configuration_file = $victoriametrics::vminsert::configuration_file
  $binary_directory = $victoriametrics::params::binary_directory
  # $service_enable   = $victoriametrics::vminsert::service_enable
  # $service_status   = $victoriametrics::vminsert::service_status

  victoriametrics::systemd::unit { $service_name:
    ensure   => $service_ensure,
    type     => 'service',
    settings => {
      'Unit'    => {
        'Description' => 'VictoriaMetrics vminsert service',
        'After'       => 'network.target',
      },
      'Service' => {
        'Type'             => 'simple',
        'User'             => $user,
        'Group'            => $group,
        'UMask'            => '0002',
        'ExecStart'        => "${binary_directory['path']}/vminsert-prod -envflag.enable",
        'EnvironmentFile'  => $configuration_file['path'],
        'Restart'          => 'on-failure',
        'RestartSec'       => '30',
        'StandardOutput'   => 'syslog',
        'StandardError'    => 'syslog',
        'PrivateTmp'       => 'yes',
        'NoNewPrivileges'  => 'yes',
        'ProtectSystem'    => 'full',
        'SyslogIdentifier' => $service_name
      },
      'Install' => {
        'WantedBy' => 'multi-user.target'
      },
    },
  }
}
