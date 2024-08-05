class victoriametrics::systemd::reload {
  exec { "${module_name}-systemctl-daemon-reload":
    command     => 'systemctl daemon-reload',
    refreshonly => true,
    path        => $facts['path'],
  }
}
