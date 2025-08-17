export def is-hdr? []: nothing -> bool {
  let hdr_formats = [
    XRGB2101010 ARGB2101010 XBGR2101010 ABGR2101010
    XRGB16161616F ARGB16161616F
  ]
  let monitors = (^hyprctl -j monitors | from json)

  $monitors | any { |monitor|
    let fmt  = ($monitor | get -o currentFormat | default "")
    ($fmt in $hdr_formats)
  }
}
