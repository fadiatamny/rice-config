---
description: Final feature guard. Keywords: auditor, verifier, cleanup. Reviews work, identifies gaps, and applies in-scope low-risk fixes.
mode: subagent
color: "#ff5c5c"
permissions:
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
