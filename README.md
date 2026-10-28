# dotfiles

macOS config for my machines, managed with [chezmoi](https://www.chezmoi.io).

## New Mac

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply vilbergs/dotfiles
```

It asks once whether this is a `work` or `personal` machine. On a work machine it then installs Homebrew,
everything in `~/.Brewfile` (CLIs and apps), oh-my-zsh, Node 24/22 via fnm, Rust via rustup,
Python via uv, and the claude-skills binaries. Homebrew asks for the sudo password once.
App Store apps (Xcode, TestFlight, Developer, Slack, Things, 1Password for Safari) are installed by hand.

On a personal machine nothing is installed automatically: run `brew bundle --global` yourself.

## Day to day

- Edit a live file, then `chezmoi re-add <file>`. On the other machine, `chezmoi update`.
- Add a package to `dot_Brewfile.tmpl`. `chezmoi apply` reruns `brew bundle` when the Brewfile changes.
- Bump a version in `.chezmoiscripts/run_onchange_after_20-toolchains.sh.tmpl` to rerun the toolchain installs.

Secrets are not in this repo. They come from 1Password.

The `master` branch holds the old (pre-2026, mostly Linux) config.
