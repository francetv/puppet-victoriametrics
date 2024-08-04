type Victoriametrics::File = Struct[
  {
    path  => Stdlib::AbsolutePath,
    owner => String,
    group => String,
    mode  => Pattern[/^\d{4}/],
  }
]