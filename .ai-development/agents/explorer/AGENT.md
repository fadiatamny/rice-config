---
description: Dedicated research subagent. Keywords: researcher, investigator, diagnostician. Deep primary-source web research and code, SQL, and operations questions; returns compact research handovers to Orchestrator.
mode: subagent
color: "#00d1c1"
permissions:
  - action: subagent
    resource: "*"
    effect: deny
  - action: subagent
    resource: "explorer"
    effect: allow
  - action: "opencode_*"
    resource: "*"
    effect: deny
  - action: execute
    resource: "*"
    effect: deny
  - action: webfetch
    resource: "*"
    effect: allow
  - action: websearch
    resource: "*"
    effect: allow
  - action: "ddg-search_*"
    resource: "*"
    effect: allow
  - action: shell
    resource: "pwd"
    effect: allow
  - action: shell
    resource: "ls *"
    effect: allow
  - action: shell
    resource: "rg *"
    effect: allow
  - action: shell
    resource: "grep *"
    effect: allow
  - action: shell
    resource: "head *"
    effect: allow
  - action: shell
    resource: "tail *"
    effect: allow
  - action: shell
    resource: "wc *"
    effect: allow
  - action: shell
    resource: "diff *"
    effect: allow
  - action: shell
    resource: "stat *"
    effect: allow
  - action: shell
    resource: "basename *"
    effect: allow
  - action: shell
    resource: "dirname *"
    effect: allow
  - action: shell
    resource: "uniq *"
    effect: allow
  - action: shell
    resource: "cut *"
    effect: allow
  - action: shell
    resource: "tr *"
    effect: allow
  - action: shell
    resource: "nl *"
    effect: allow
  - action: shell
    resource: "file *"
    effect: allow
  - action: shell
    resource: "realpath *"
    effect: allow
  - action: shell
    resource: "readlink *"
    effect: allow
  - action: shell
    resource: "printf *"
    effect: allow
  - action: shell
    resource: "date *"
    effect: allow
  - action: shell
    resource: "uname *"
    effect: allow
  - action: shell
    resource: "jq *"
    effect: allow
  - action: shell
    resource: "ps *"
    effect: allow
  - action: shell
    resource: "git grep *"
    effect: allow
  - action: shell
    resource: "git blame *"
    effect: allow
  - action: shell
    resource: "git status *"
    effect: allow
  - action: shell
    resource: "git diff *"
    effect: allow
  - action: shell
    resource: "git log *"
    effect: allow
  - action: shell
    resource: "git show *"
    effect: allow
  - action: shell
    resource: "git branch"
    effect: allow
  - action: shell
    resource: "git branch --list *"
    effect: allow
  - action: shell
    resource: "git branch --show-current"
    effect: allow
  - action: shell
    resource: "git rev-parse *"
    effect: allow
  - action: shell
    resource: "git ls-files *"
    effect: allow
  - action: shell
    resource: "git remote -v"
    effect: allow
  - action: shell
    resource: "which *"
    effect: allow
  - action: shell
    resource: "command -v *"
    effect: allow
  - action: shell
    resource: "cat *.md"
    effect: allow
  - action: shell
    resource: "cat *.txt"
    effect: allow
  - action: shell
    resource: "cat *.json"
    effect: allow
  - action: shell
    resource: "cat *.jsonc"
    effect: allow
  - action: shell
    resource: "cat *.yaml"
    effect: allow
  - action: shell
    resource: "cat *.yml"
    effect: allow
  - action: shell
    resource: "cat *.toml"
    effect: allow
  - action: shell
    resource: "git push*"
    effect: deny
  - action: shell
    resource: "*&&*git push*"
    effect: deny
  - action: shell
    resource: "*;*git push*"
    effect: deny
  - action: shell
    resource: "*|*git push*"
    effect: deny
  - action: shell
    resource: "rm -rf*"
    effect: deny
  - action: shell
    resource: "rm -fr*"
    effect: deny
  - action: shell
    resource: "*&&*rm -rf*"
    effect: deny
  - action: shell
    resource: "*;*rm -rf*"
    effect: deny
  - action: shell
    resource: "*|*rm -rf*"
    effect: deny
  - action: shell
    resource: "*&&*rm -fr*"
    effect: deny
  - action: shell
    resource: "*;*rm -fr*"
    effect: deny
  - action: shell
    resource: "*|*rm -fr*"
    effect: deny
  - action: shell
    resource: "*rg *--pre*"
    effect: deny

---
