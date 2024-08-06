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

  unless $victoriametrics_version == $version {
    file { $root_install['path']:
      ensure  => directory,
      recurse => true,
      purge   => true,
      owner   => 'root',
      group   => 'root',
    }
    file { "${root_install['path']}/${version}":
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => 'ug+r',
    }
  }

  archive { "/tmp/${archive_name}.tar.gz":
    ensure       => $ensure,
    creates      => "${root_install['path']}/${version}",
    source       => $download_url,
    extract      => true,
    extract_path => "${root_install['path']}/${version}",
    user         => 'root',
    group        => 'root',
    require      => File["${root_install['path']}/${version}"]
  }
  file { $binary_directory['path']:
    ensure  => link,
    owner   => 'root',
    group   => 'root',
    target  => "${root_install['path']}/${version}",
    require => Archive["/tmp/${archive_name}.tar.gz"]
  }
}
