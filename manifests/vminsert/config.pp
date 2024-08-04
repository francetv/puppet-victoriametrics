# PRIVATE CLASS: do not call directly
class victoriametrics::vminsert::config {
  $ensure = $victoriametrics::vminsert::ensure
  $user = $victoriametrics::params::user
  $group = $victoriametrics::params::group
  $binary_directory = $victoriametrics::params::binary_directory
  $configuration_directory = $victoriametrics::vminsert::configuration_directory
  $configuration_file = $victoriametrics::vminsert::configuration_file
  $relabeling_configuration_file = $victoriametrics::vminsert::relabeling_configuration_file
  $configuration_map = $victoriametrics::vminsert::configuration_map
  $relabeling_configuration_map = $victoriametrics::vminsert::relabeling_configuration_map
  $storage_nodes = $victoriametrics::vminsert::storage_nodes

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
    content => template("${module_name}/vminsert.conf.erb"),
  }
  file { 'relabeling_configuration_file':
    *       => $relabeling_configuration_file,
    content => stdlib::to_yaml($relabeling_configuration_map),
  }
}
