---
description: Primary mission owner. Keywords: conductor, planner, dispatcher. Owns all research, daily, repository, and implementation work; coordinates specialists when needed.
mode: primary
color: "#f5a623"
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
---
