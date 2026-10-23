---
description: Research and exploration helper. Keywords: researcher, investigator, diagnostician. Deep primary-source web research and code, SQL, and operations questions; returns findings and implementation briefs to the orchestrator.
mode: all
permissions:
  - action: subagent
    resource: "*"
    effect: deny
  - action: webfetch
    resource: "*"
    effect: allow
  - action: websearch
    resource: "*"
    effect: allow
---
