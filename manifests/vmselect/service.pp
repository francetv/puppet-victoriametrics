# PRIVATE CLASS: do not call directly
class victoriametrics::vmselect::service {
  $service_ensure = $victoriametrics::params::ensure
  $service_name = $victoriametrics::vmselect::service_name
  $service_manage = $victoriametrics::vmselect::service_manage
  $user = $victoriametrics::params::user
  $group = $victoriametrics::params::group
  $configuration_file = $victoriametrics::vmselect::configuration_file
  $binary_directory = $victoriametrics::params::binary_directory
  $cache_directory = $victoriametrics::vmselect::cache_directory
  # $service_enable   = $victoriametrics::vmselect::service_enable
  # $service_status   = $victoriametrics::vmselect::service_status

  victoriametrics::systemd::unit { $service_name:
    ensure   => $service_ensure,
    type     => 'service',
    settings => {
      'Unit'    => {
        'Description' => 'VictoriaMetrics vmselect service',
        'After'       => 'network.target',
      },
      'Service' => {
        'Type'             => 'simple',
        'User'             => $user,
        'Group'            => $group,
        'UMask'            => '0002',
        'ExecStart'        => "${binary_directory['path']}/vmselect-prod -envflag.enable",
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
