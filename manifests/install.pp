# PRIVATE CLASS: do not call directly
class victoriametrics::install (
  $archive_name = $victoriametrics::params::archive_name
) {
  assert_private()
  $version = $victoriametrics::params::version
  $ensure = $victoriametrics::params::ensure
  $root_install = $victoriametrics::params::root_install
  $binary_directory = $victoriametrics::params::binary_directory
  $repository_url = $victoriametrics::params::repository_url
  $platform = $victoriametrics::params::platform
  $download_url = "${repository_url}/releases/download/${version}/${archive_name}.tar.gz"

  file { $root_install['path']:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  }
  file { $binary_directory['path']:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  }

  archive { "/tmp/${archive_name}.tar.gz":
    ensure       => $ensure,
    source       => $download_url,
    extract      => true,
    extract_path => "${binary_directory['path']}",
    unless       => [
      "test $(${binary_directory['path']}/vmstorage-prod --version 2>&1 | tr '-' ' ' | awk '{print $5}') = '${version}'",
    ],
    user         => 'root',
    group        => 'root',
    env_path     => ["/bin", "/usr/bin", "/sbin", "/usr/sbin"],
  }
}
