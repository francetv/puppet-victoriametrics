# PRIVATE CLASS: do not call directly
class victoriametrics::vmstorage::config {
  $ensure = $victoriametrics::vmstorage::ensure
  $user = $victoriametrics::params::user
  $group = $victoriametrics::params::group
  $binary_directory = $victoriametrics::params::binary_directory
  $configuration_directory = $victoriametrics::vmstorage::configuration_directory
  $configuration_file = $victoriametrics::vmstorage::configuration_file
  $data_directory = $victoriametrics::vmstorage::data_directory
  $configuration_map = $victoriametrics::vmstorage::configuration_map

  file { 'configuration_directory':
    * => $configuration_directory,
  }
  file { 'configuration_file':
    *       => $configuration_file,
    content => template("${module_name}/vmstorage.conf.erb"),
  }
  file { 'data_directory':
    * => $data_directory,
  }
}
