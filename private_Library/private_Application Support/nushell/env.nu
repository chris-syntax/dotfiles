# env.nu — macOS Nushell entry point  (chezmoi: darwin only)
#
# A Nushell login shell does NOT execute /etc/profile, so macOS's
# `path_helper` and Homebrew's `brew shellenv` never run. This file rebuilds
# the environment they would have provided, then hands off to the shared,
# cross-platform config in ~/.config/nushell.

# --- 1. System PATH via the canonical macOS path_helper ---------------------
# path_helper composes PATH from /etc/paths and /etc/paths.d/* (this already
# includes /opt/homebrew/bin). It normally runs from /etc/profile, which a
# Nushell login shell never sources, so we invoke it directly and parse its
# POSIX output. Run it with an emptied PATH so we get only the system entries
# (path_helper otherwise *appends* the current PATH).
let system_paths = (
    with-env { PATH: "" } { ^/usr/libexec/path_helper -s }
    | parse --regex 'PATH="(?<p>[^"]*)"'
    | get p.0
    | split row (char esep)
    | where {|p| $p | is-not-empty }
)

# --- 2. Homebrew (equivalent of `brew shellenv`) ----------------------------
$env.HOMEBREW_PREFIX = '/opt/homebrew'
$env.HOMEBREW_CELLAR = '/opt/homebrew/Cellar'
$env.HOMEBREW_REPOSITORY = '/opt/homebrew'
$env.INFOPATH = $"/opt/homebrew/share/info:($env.INFOPATH? | default '')"

# --- 3. Compose the base PATH (Homebrew sbin + system), de-duplicated -------
$env.PATH = (
    ['/opt/homebrew/sbin']
    | append $system_paths
    | append ($env.PATH? | default [])
    | uniq
)

# --- 4. Login niceties normally provided by the terminal / POSIX profile ----
$env.XDG_CONFIG_HOME = ($env.HOME | path join '.config')
$env.GPG_TTY = (try { ^tty | str trim } catch { '' })

# --- 5. Hand off to the shared, cross-platform configuration ----------------
source ~/.config/nushell/env.nu
