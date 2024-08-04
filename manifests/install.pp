# PRIVATE CLASS: do not call directly
class victoriametrics::install {
  assert_private()
  $version = $victoriametrics::params::version
  $user = $victoriametrics::params::user
  $group = $victoriametrics::params::group
  $ensure = $victoriametrics::params::ensure
  $binary_directory = $victoriametrics::params::binary_directory
  $repository_url = $victoriametrics::params::repository_url
  $platform = $victoriametrics::params::platform
  $archive_name = $victoriametrics::params::archive_name
  $download_url = $victoriametrics::params::download_url

  unless $victoriametrics_version == $version {
    archive { $archive_name:
      ensure       => $ensure,
      creates      => $binary_directory['path'],
      source       => $download_url,
      extract      => true,
      extract_path => $binary_directory['path'],
      user         => $user,
      group        => $group,
      path         => "${binary_directory['path']}/${archive_name}.tar.gz",
      cleanup      => true,
    }
  }
}
