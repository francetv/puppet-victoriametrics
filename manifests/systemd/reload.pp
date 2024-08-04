class victoriametrics::systemd::reload {
  exec { 'systemctl-daemon-reload':
    command     => 'systemctl daemon-reload',
    refreshonly => true,
    path        => $facts['path'],
  }
}
