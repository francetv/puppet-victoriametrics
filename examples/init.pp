class { 'victoriametrics::vmstorage':

}

class { 'victoriametrics::vminsert':
  storage_nodes => [
    'vmstorage-1:8400',
    'vmstorage-2:8400'
  ],
}

class { 'victoriametrics::vmselect':
  storage_nodes => [
    'vmstorage-1:8400',
    'vmstorage-2:8400'
  ],
}
