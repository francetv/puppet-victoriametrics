# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include victoriametrics::vmagent
class victoriametrics::vmagent (
  $user                                                        = $victoriametrics::params::user,
  $group                                                       = $victoriametrics::params::group,
  $shell                                                       = $victoriametrics::params::shell,
  $version                                                     = $victoriametrics::params::version,
  Variant[Boolean, String] $ensure                             = $victoriametrics::params::ensure,
  Boolean $enterprise                                          = undef,
  Boolean $restart                                             = undef,
  Victoriametrics::File $configuration_directory               = $victoriametrics::params::configuration_directory,
  Victoriametrics::File $configuration_file                    = undef,
  String $service_name                                         = undef,
  String $service_ensure                                       = undef,
  Boolean $service_manage                                      = undef,
  Boolean $service_enable                                      = undef,
  Boolean $service_status                                      = undef,
  Hash $promscrape_config                                      = undef,
  Variant[Stdlib::HTTPUrl, Stdlib::HTTPSUrl] $remote_write_url = undef,
  String[1] $promscrape_max_scrape_size                        = undef,
  String[1] $promscrape_stream_parse                           = undef,
) inherits victoriametrics::params {
  contain victoriametrics::user
  contain victoriametrics::vmutils
  contain victoriametrics::vmagent::config
  contain victoriametrics::vmagent::service

  if ($ensure == 'present' or $ensure == true) {
    Class['victoriametrics::user'] -> Class['victoriametrics::vmutils'] -> Class['victoriametrics::vmagent::config']

    if $restart {
      # If $restart is true, notify the service on config changes (~>)
      Class['victoriametrics::vmagent::config'] ~> Class['victoriametrics::vmagent::service']
    } else {
      # If $restart is false, config changes won't restart the service (->)
      Class['victoriametrics::vmagent::config'] -> Class['victoriametrics::vmagent::service']
    }
  } else {
    Class['victoriametrics::vmagent::service'] -> Class['victoriametrics::vmagent::config'] -> Class['victoriametrics::install']
  }
}
