# PRIVATE CLASS: do not call directly
class victoriametrics::vmagent::config {
  $ensure = $victoriametrics::vmagent::ensure
  $user = $victoriametrics::params::user
  $group = $victoriametrics::params::group
  $binary_directory = $victoriametrics::params::binary_directory
  $configuration_directory = $victoriametrics::vmagent::configuration_directory
  $configuration_file = $victoriametrics::vmagent::configuration_file
  $promscrape_config = $victoriametrics::vmagent::promscrape_config

  file { 'configuration_directory':
    ensure => 'directory',
    *      => $configuration_directory,
  }
  file { 'configuration_file':
    *       => $configuration_file,
    content => stdlib::to_yaml($promscrape_config),
    require => File['configuration_directory']
  }
}
