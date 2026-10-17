# rice-config
Rice configurations for cross platform dev environment

### The terminal config
Emulator of choice is [Wezterm](https://wezfurlong.org/wezterm)

The .zshrc provided should handle installing all needed configurations

# VS CODE
Chosen Theme for IDE is [Tokyo Night](enkia.tokyo-night)
### Shortcuts
- `Ctrl + Shift + \`    Fold all
- `Ctrl + Alt + \`      Unfold all
- `Ctrl + Shift + R`    reload window
- `Ctrl + Alt + -`      Go back
- `Ctrl + Shift + -`    Go forward
- `Ctrl + Shift + I`    Format document

# Necessities to install
- fzf
- zoxide
- thefuck

# Addons
- Conda
    - check [this](https://stackoverflow.com/questions/67380286/anaconda-channel-for-installing-python-2-7) for conda 2.7 on apple silicon
    - conda config --set changeps1 false
- NVM
- Go Version Manager gvm
- lazygit


### Easy install
Using symlink and the GNU stow

```sh
git clone https://github.com/fadiatamny/rice-config.git
cd rice-config
stow .
```

### AI environment

Run `./ai.sh` to install the optional AI tools. It can also install
[Strata](https://github.com/Niko1221/Strata) and the original
Qwen3.8-Flash-Next model. Strata is opt-in: the script confirms before its
roughly 70 GB model download, asks where to store model data, and keeps its
server local-only. On Linux systems with a writable `/mnt`, its default model
data directory is `/mnt/strata-data`; set `STRATA_REPO_DIR` to change the
Strata checkout location.
