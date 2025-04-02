# PRIVATE CLASS: do not call directly
class victoriametrics::vmagent::service {
  $ensure = $victoriametrics::params::ensure
  $service_name = $victoriametrics::vmagent::service_name
  $user = $victoriametrics::params::user
  $group = $victoriametrics::params::group
  $configuration_file = $victoriametrics::vmagent::configuration_file
  $binary_directory = $victoriametrics::params::binary_directory
  $tmp_data_path = $victoriametrics::params::tmp_data_path
  $service_enable = $victoriametrics::vmagent::service_enable
  $service_status = $victoriametrics::vmagent::service_status
  $service_manage = $victoriametrics::vmagent::service_manage
  $promscrape_config = $victoriametrics::vmagent::promscrape_config
  $remote_write_url = $victoriametrics::vmagent::remote_write_url
  $promscrape_max_scrape_size = $victoriametrics::vmagent::promscrape_max_scrape_size
  $promscrape_stream_parse = $victoriametrics::vmagent::promscrape_stream_parse

  $service_ensure = $ensure ? {
    'present' => true,
    default   => false
  }

  if $service_manage {
    $cmd_default = [
      "--promscrape.config=${configuration_file['path']}",
      "--remoteWrite.tmpDataPath=${tmp_data_path['path']}",
      "--remoteWrite.url=${remote_write_url}",
      "--promscrape.maxScrapeSize=${promscrape_max_scrape_size}",
      "--promscrape.streamParse",
    ]

    systemd::manage_unit { "${service_name}.service":
      ensure        => $ensure,
      enable        => $service_enable,
      active        => $service_ensure,
      unit_entry    => {
        'Description' => 'VictoriaMetrics vmagent service',
        'After'       => 'network.target',
      },
      service_entry => {
        'Type'             => 'simple',
        'User'             => $user,
        'Group'            => $group,
        'UMask'            => '0002',
        'ExecStart'        => "${binary_directory['path']}/vmagent-prod ${cmd_default.join(' ')}",
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
      ensure => $service_ensure,
      name   => $service_name,
    }
  }
}
