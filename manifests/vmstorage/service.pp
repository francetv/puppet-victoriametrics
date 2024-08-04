# PRIVATE CLASS: do not call directly
class victoriametrics::vmstorage::service {
  $service_ensure = $victoriametrics::params::ensure
  $service_name = $victoriametrics::vmstorage::service_name
  $service_manage = $victoriametrics::vmstorage::service_manage
  $user = $victoriametrics::params::user
  $group = $victoriametrics::params::group
  $configuration_file = $victoriametrics::vmstorage::configuration_file
  $binary_directory = $victoriametrics::params::binary_directory
  $data_directory = $victoriametrics::vmstorage::data_directory
  # $service_enable   = $victoriametrics::vmstorage::service_enable
  # $service_status   = $victoriametrics::vmstorage::service_status

  victoriametrics::systemd::unit { $service_name:
    ensure   => $service_ensure,
    type     => 'service',
    settings => {
      'Unit'    => {
        'Description' => 'VictoriaMetrics vmstorage service',
        'After'       => 'network.target',
      },
      'Service' => {
        'Type'             => 'simple',
        'User'             => $user,
        'Group'            => $group,
        'UMask'            => '0002',
        'WorkingDirectory' => $data_directory['path'],
        'ExecStart'        => "${binary_directory['path']}/vmstorage-prod -envflag.enable",
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
