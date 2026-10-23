---
name: state-tracker
description: Keep file context fresh for every analysis, edit, repair, and review. Use before relying on source files that may have changed.
---

# Fresh Context

Reread every relevant file immediately before the decision that depends on it:
before analyzing, editing, repairing, and reviewing a diff.

Current disk state beats any earlier read, plan, or agent report. Do not reread
unrelated files. If current state invalidates the assigned scope, stop and report
the blocker.
