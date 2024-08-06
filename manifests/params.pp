# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include victoriametrics::params
class victoriametrics::params (
  Variant[Boolean, String] $ensure               = undef,
  String $version                                = undef,
  Victoriametrics::File $configuration_directory = undef,
  Victoriametrics::File $root_install            = undef,
  Victoriametrics::File $binary_directory        = undef,
  String $user                                   = undef,
  String $group                                  = undef,
  String $shell                                  = undef,
  String $repository_url                         = undef,
  String $platform                               = undef,
  String $architecture                           = undef,
  String $archive_name                           = undef,
) {
}
