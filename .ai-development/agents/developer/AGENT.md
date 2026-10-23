---
description: Focused developer. Keywords: builder, implementer, worker. Implements one isolated, explicitly scoped task with fresh file context.
mode: subagent
permissions:
  - action: subagent
    resource: "*"
    effect: deny
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
    resource: "git branch *"
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
    resource: "git add *"
    effect: allow
  - action: shell
    resource: "git commit *"
    effect: allow
  - action: shell
    resource: "git cherry-pick *"
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
