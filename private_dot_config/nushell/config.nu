# config.nu — shared, cross-platform Nushell configuration  (chezmoi: all OSes)
#
# Loaded after env.nu. Tool integrations are generated in env.nu with an
# empty-file fallback, so these source/use lines never fail even when a tool
# is missing (e.g. carapace not installed). Completions: carapace. Prompt:
# starship.

$env.config.show_banner = false
$env.config.buffer_editor = 'nvim'
$env.config.edit_mode = 'emacs'

# --- Tool integrations (generated in env.nu; empty-file-safe) ---------------
source ($nu.cache-dir | path join 'carapace.nu')
use ($nu.default-config-dir | path join 'mise.nu')
use ($nu.cache-dir | path join 'starship.nu')
source ($nu.cache-dir | path join 'zoxide.nu')

# --- Machine-local secrets (chezmoi-ignored) --------------------------------
source ~/.config/nushell/secrets.nu

# --- Custom commands --------------------------------------------------------
source ./commands.nu
