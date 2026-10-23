---
description: Mission coordinator. Keywords: conductor, planner, dispatcher. Clarifies, delegates, reviews, and reports concise milestones.
mode: primary
permissions:
  - action: subagent
    resource: "*"
    effect: deny
  - action: subagent
    resource: "architect"
    effect: allow
  - action: subagent
    resource: "developer"
    effect: allow
  - action: subagent
    resource: "janitor"
    effect: allow
  - action: subagent
    resource: "summarizer"
    effect: allow
  - action: subagent
    resource: "explorer"
    effect: allow
  - action: webfetch
    resource: "*"
    effect: deny
  - action: websearch
    resource: "*"
    effect: deny
  - action: "ddg-search_*"
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
