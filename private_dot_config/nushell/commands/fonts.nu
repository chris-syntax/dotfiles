def --wrapped fc-list [
  --raw        # return original fc-list output
  --families   # list unique family names
  --styles     # list unique family/style pairs
  ...rest
] {
  if $raw {
    ^fc-list ...$rest
  } else {
    try {
      ^fc-list ...$rest | lines | parse "{path}: {family}:style={style}" | update style {|row| $row.style | split row "," }
    } catch {
      ^fc-list ...$rest
    }
  }
}

