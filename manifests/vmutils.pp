# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include victoriametrics::vminsert
class victoriametrics::vmutils (
  $version                                                = $victoriametrics::params::version,
  Variant[Boolean, String] $ensure                        = $victoriametrics::params::ensure,
  Boolean $enterprise                                     = undef,
  String $repository_url                                  = $victoriametrics::params::repository_url,
  String $platform                                        = $victoriametrics::params::platform,
  String $archive_name                                    = undef,
) inherits victoriametrics::params {

  class { 'victoriametrics::install':
    archive_name => $archive_name,
  }
}
