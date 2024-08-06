# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include victoriametrics::vminsert
class victoriametrics::vminsert (
  $user                                                   = $victoriametrics::params::user,
  $group                                                  = $victoriametrics::params::group,
  $shell                                                  = $victoriametrics::params::shell,
  $version                                                = $victoriametrics::params::version,
  Variant[Boolean, String] $ensure                        = $victoriametrics::params::ensure,
  Boolean $enterprise                                     = undef,
  Boolean $restart                                        = undef,
  Victoriametrics::File $configuration_directory          = $victoriametrics::params::configuration_directory,
  Victoriametrics::File $configuration_file               = undef,
  Victoriametrics::File $relabeling_configuration_file    = undef,
  Hash $configuration_map                                 = undef,
  Variant[Boolean, Hash] $relabeling_configuration_map    = undef,
  Optional[Victoriametrics::Storage_nodes] $storage_nodes = undef,
  String $service_name                                    = undef,
  String $service_ensure                                  = undef,
  Boolean $service_manage                                 = undef,
  Boolean $service_enable                                 = undef,
  Boolean $service_status                                 = undef,
) inherits victoriametrics::params {
  contain victoriametrics::user
  contain victoriametrics::install
  contain victoriametrics::vminsert::config
  contain victoriametrics::vminsert::service

  if ($ensure == 'present' or $ensure == true) {
    Class['victoriametrics::user'] -> Class['victoriametrics::install'] -> Class['victoriametrics::vminsert::config']

    if $restart {
      # If $restart is true, notify the service on config changes (~>)
      Class['victoriametrics::vminsert::config'] ~> Class['victoriametrics::vminsert::service']
    } else {
      # If $restart is false, config changes won't restart the service (->)
      Class['victoriametrics::vminsert::config'] -> Class['victoriametrics::vminsert::service']
    }
  } else {
    Class['victoriametrics::vminsert::service'] -> Class['victoriametrics::vminsert::config'] -> Class['victoriametrics::install']
  }
}
