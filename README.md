# dotfiles

macOS config for my machines, managed with [chezmoi](https://www.chezmoi.io).

```sh
brew install chezmoi
chezmoi init --apply vilbergs/dotfiles
```

Day to day: edit the live file, then `chezmoi re-add <file>`; on the other machine, `chezmoi update`.
Secrets are not in this repo. They come from 1Password.

The `master` branch holds the old (pre-2026, mostly Linux) config.
