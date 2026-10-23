---
description: Architecture planner. Keywords: analyst, specifier, planner. Defines acceptance criteria, dependencies, and safe work boundaries without editing.
mode: subagent
color: "#4aa3ff"
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
  - action: "opencode_*"
    resource: "*"
    effect: deny
  - action: execute
    resource: "*"
    effect: deny
  - action: question
    resource: "*"
    effect: deny
  - action: subagent
    resource: "*"
    effect: deny
---
