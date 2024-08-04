# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include victoriametrics::vmselect
class victoriametrics::vmselect (
  $user                                                   = $victoriametrics::params::user,
  $group                                                  = $victoriametrics::params::group,
  $shell                                                  = $victoriametrics::params::shell,
  $version                                                = $victoriametrics::params::version,
  Variant[Boolean, String] $ensure                        = $victoriametrics::params::ensure,
  Boolean $enterprise                                     = undef,
  Boolean $restart                                        = undef,
  String $repository_url                                  = $victoriametrics::params::repository_url,
  String $platform                                        = $victoriametrics::params::platform,
  String $download_url                                    = $victoriametrics::params::download_url,
  String $archive_name                                    = $victoriametrics::params::archive_name,
  Victoriametrics::File $configuration_directory          = $victoriametrics::params::configuration_directory,
  Victoriametrics::File $configuration_file               = undef,
  Victoriametrics::File $cache_directory                  = undef,
  Hash $configuration_map                                 = undef,
  Optional[Victoriametrics::Storage_nodes] $storage_nodes = undef,
  String $service_name                                    = undef,
  String $service_ensure                                  = undef,
  Boolean $service_manage                                 = undef,
) inherits victoriametrics::params {
  contain victoriametrics::user
  contain victoriametrics::install
  contain victoriametrics::vmselect::config
  contain victoriametrics::vmselect::service
  contain victoriametrics::systemd::reload

  if ($ensure == 'present' or $ensure == true) {
    Class['victoriametrics::user'] -> Class['victoriametrics::install'] -> Class['victoriametrics::vmselect::config']

    if $restart {
      # If $restart is true, notify the service on config changes (~>)
      Class['victoriametrics::vmselect::config'] ~> Class['victoriametrics::vmselect::service']
    } else {
      # If $restart is false, config changes won't restart the service (->)
      Class['victoriametrics::vmselect::config'] -> Class['victoriametrics::vmselect::service']
    }
  } else {
    Class['victoriametrics::vmselect::service'] -> Class['victoriametrics::vmselect::config'] -> Class['victoriametrics::install']
  }
}
