# dotfiles

Managed with [chezmoi](https://chezmoi.io). Cross-platform (Linux / macOS); the
`cd` shell and machine-specific bits are templated per-OS.

## Bootstrap a new machine

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply chris-syntax
```

Then check out the branch you want (this is the `linux_custom` line):

```sh
chezmoi cd
git checkout linux_custom
chezmoi apply
```

### Prerequisites

- **1Password** desktop app, with the **SSH agent** enabled
  (Settings → Developer → Use the SSH agent). This provides both SSH auth and
  git commit signing — no private keys live on disk.
  - `.ssh/config` resolves the agent socket per-OS automatically.
  - Git signing uses `op-ssh-sign` (`gpg.format = ssh`); the program path is
    templated (`/opt/1Password/op-ssh-sign` on Linux,
    `/Applications/1Password.app/Contents/MacOS/op-ssh-sign` on macOS).
  - Only the **public** keys (`personal.pub`, `work.pub`) are tracked.
- **nushell** — primary shell. `mise` and `starship` auto-activate on startup
  via `.config/nushell/env.nu` + `config.nu`; no manual step needed.
- **mise** — tool versions in `.config/mise/config.toml` (node/ruby/uv). Run
  `mise install` once to materialize them.

## KDE Plasma (Linux only)

KDE config is gated to Linux in `.chezmoiignore`, so it never lands on macOS.
Tracked: `kdeglobals`, `kglobalshortcutsrc`, `kwinrc`, `kxkbrc`, `kcminputrc`,
`plasmarc`, `ksmserverrc`, `dolphinrc`, and
`plasma-org.kde.plasma.desktop-appletsrc` (panels + wallpaper).

**Not tracked** (machine-specific): `kwinoutputconfig.json`, `monitors.xml` —
display geometry. Configure monitors fresh on each box.

### Video wallpaper — "Smart Video Wallpaper Reborn"

The wallpaper uses the [Smart Video Wallpaper Reborn](https://github.com/luisbocanegra/plasma-smart-video-wallpaper-reborn)
plugin. Both the plugin (`~/.local/share/plasma/wallpapers/luisbocanegra.smart.video.wallpaper.reborn`)
and the video (`~/Pictures/Wallpapers/mount-fujiyama.3840x2160.mp4`) are tracked,
so `chezmoi apply` lays everything down. To make Plasma pick it up:

1. `chezmoi apply` (installs plugin + video + appletsrc).
2. **Log out and back in** (or restart Plasma: `systemctl --user restart plasma-plasmashell`)
   so the newly-installed wallpaper plugin is registered.
3. If the desktop doesn't show it: right-click desktop → *Configure Desktop and
   Wallpaper* → Wallpaper type *Smart Video Wallpaper Reborn* → confirm the video
   points at `~/Pictures/Wallpapers/mount-fujiyama.3840x2160.mp4`.

> Note: `appletsrc` stores a live `LastVideoPosition` that Plasma rewrites
> constantly, so `chezmoi diff` will show harmless drift on that line. Only
> re-run `chezmoi add ~/.config/plasma-org.kde.plasma.desktop-appletsrc` when you
> intentionally change panels/widgets. Panel layout is tied to this machine's
> monitor arrangement and may need a re-tidy on differently-configured hardware.
