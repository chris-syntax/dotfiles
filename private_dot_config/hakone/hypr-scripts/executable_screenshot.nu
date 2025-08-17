#!/usr/bin/env nu
use ~/.config/hakone/lib/monitors.nu *

def main [
  --region # select a region of the screen
  --window # select a window
  --to-file # output to a file
] {
  let region = find_region --region=$region --window=$window
  grim -g $region - | tonemap-hdr | wl-copy --type image/png
}

def send_to_target [
  --to-file
]: any -> any {
  if ($to_file) {
    let timestamp = date now | format date "%Y%m%d_%H%M%S%3f"
    $in | save -f $"~/Pictures/($timestamp)_screenshot.png"
  } else {
    $in | wl-copy --type image/png
  }
}

def tonemap-hdr []: any -> any {
  if (is-hdr?) {
    $in | magick - +repage -auto-level -sigmoidal-contrast 4x65% png:-
  } else {
    $in
  }
}

def find_region [
  --region
  --window
]: nothing -> string {
  if ($window) {
    let window_properties = hyprctl activewindow -j | from json
    let position = $window_properties | get at | str join ','
    let size = $window_properties | get size | str join 'x'
    $"($position) ($size)"
  } else if ($region) {
    slurp
  } else {
    # Default to a screenshot of the current monitor
    let $monitor_id = hyprctl activewindow -j | from json | get monitor
    let $monitor = hyprctl monitors -j | from json | where id == $monitor_id | first
    let $width = $monitor | get width
    let $height = $monitor | get height

    $"0,0 ($width)x($height)"
  }
}
