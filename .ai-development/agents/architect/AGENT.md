---
description: Architecture planner. Keywords: analyst, specifier, planner. Defines acceptance criteria, dependencies, and safe work boundaries without editing.
mode: subagent
permissions:
  - action: edit
    resource: "*"
    effect: deny
  - action: shell
    resource: "*"
    effect: deny
  - action: webfetch
    resource: "*"
    effect: deny
  - action: websearch
    resource: "*"
    effect: deny
  - action: "ddg-search_*"
    resource: "*"
    effect: deny
  - action: subagent
    resource: "*"
    effect: deny
---
