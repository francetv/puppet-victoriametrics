# PRIVATE CLASS: do not call directly
class victoriametrics::user {
  assert_private()
  $user = $victoriametrics::params::user
  $group = $victoriametrics::params::group
  $shell = $victoriametrics::params::shell
  $ensure = $victoriametrics::params::ensure
  $binary_directory = $victoriametrics::params::binary_directory

  group { $group:
    ensure  => $ensure,
    system  => true,
    before  => User[$user],
    members => [$user]
  }
  user { $user:
    ensure  => $ensure,
    comment => 'Victoriametrics User',
    system  => true,
    gid     => $group,
    shell   => $shell,
    home    => $binary_directory['path'],
    require => Group[$group]
  }
}
