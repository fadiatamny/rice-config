---
description: Research and exploration helper. Keywords: researcher, investigator, diagnostician. Deep primary-source web research and code, SQL, and operations questions; returns findings and implementation briefs to the orchestrator.
mode: all
permissions:
  - action: subagent
    resource: "*"
    effect: deny
  - action: subagent
    resource: "architect"
    effect: allow
  - action: webfetch
    resource: "*"
    effect: allow
  - action: websearch
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
---
