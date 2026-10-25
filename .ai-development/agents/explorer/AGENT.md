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
---
