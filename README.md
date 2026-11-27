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

# Managed shell dependencies

`rice.sh` installs:

- git
- fzf
- zoxide
- eza
- lazygit

# Optional additions
- Conda
    - check [this](https://stackoverflow.com/questions/67380286/anaconda-channel-for-installing-python-2-7) for conda 2.7 on apple silicon
    - conda config --set changeps1 false
- NVM
- Go Version Manager gvm


### Easy install
Using symlink and the GNU stow

```sh
git clone https://github.com/fadiatamny/rice-config.git
cd rice-config
stow .
```

### AI environment

Run `./ai.sh` to install the optional AI tools.

The Ollama setup reads its model pull list and storage settings from the
repository's [`.env`](.env) file. On Linux with a writable `/mnt`, model storage
defaults to `/mnt/ollama-models`; the installer creates a systemd override so
the Ollama service keeps using that location. Existing models are not moved
automatically after changing the model-data directory.

`ai.sh` loads the repository's [`.env`](.env) file before applying these
settings, and `rice.sh` deploys it to `~/.config/rice-config/.env` for login
shells to load. It centralizes Ollama options. It is tracked configuration:
keep all API-key fields empty and provide real secrets only through an
untracked local source.

On a first run, `ai.sh` adds only missing repository-managed OpenCode and
AI-development entries, preserving files already present in their destination
directories. `ai.sh --update` replaces the repository-managed
`~/.ai-development` tree and updates repository-managed OpenCode files; invoke
it only when that replacement is intended. Update requires interactive
confirmation. Existing files in `~/.config/opencode/agents` are not deleted:
review them for conflicts with the configured agents and remove any unwanted
files manually. File-based definitions can merge with direct configuration.

`orchestrator` is the default primary agent and owns general, daily, repository,
and implementation work. It researches directly or delegates focused,
independent investigation to `explorer`, which returns compact research
handovers for the next decision. Explorer can fan out only to focused Explorer
subagents, does not own the implementation pipeline, and cannot be selected as
a primary chat agent.

`.ai-development/POLICY.md` is the portable, always-loaded baseline for every
runner. Agent personas and skills are loaded only when that role or protocol is
needed. OpenCode registers agents directly in `.config/opencode/opencode.jsonc`
and loads each portable `.ai-development/agents/<name>/PERSONA.md` as its system
prompt. The retained `AGENT.md` files also contain agent metadata and permissions;
keep those definitions aligned with the configuration until their separate removal
is authorized. The installer no longer generates combined agent files.

Only `orchestrator` and `developer` keep Code Mode (`execute`), because the
native worktree and session tools live there. Research, planning, review, and
summarization agents deny it, which also keeps their tool catalogs small.
Subagents other than `explorer` also deny `question`, so they report blockers
through `handover` instead of prompting the user directly.
