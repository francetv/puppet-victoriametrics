# PRIVATE CLASS: do not call directly
class victoriametrics::vmselect::config {
  $ensure = $victoriametrics::vmselect::ensure
  $user = $victoriametrics::params::user
  $group = $victoriametrics::params::group
  $binary_directory = $victoriametrics::params::binary_directory
  $configuration_directory = $victoriametrics::vmselect::configuration_directory
  $configuration_file = $victoriametrics::vmselect::configuration_file
  $cache_directory = $victoriametrics::vmselect::cache_directory
  $configuration_map = $victoriametrics::vmselect::configuration_map
  $storage_nodes = $victoriametrics::vmselect::storage_nodes

  if $storage_nodes {
    $config = $configuration_map + { 'storageNode' => join($storage_nodes, ',') }
  } else {
    $config = $configuration_map
  }

  file { 'configuration_directory':
    * => $configuration_directory,
  }
  file { 'configuration_file':
    *       => $configuration_file,
    content => template("${module_name}/vmselect.conf.erb"),
  }
  file { 'cache_directory':
    * => $cache_directory,
  }
}
