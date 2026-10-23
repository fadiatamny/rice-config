---
name: state-tracker
description: Keep file context fresh for every analysis, edit, repair, and review. Use before relying on source files that may have changed.
---

# Fresh Context Protocol

## Core rule

Never analyze, edit, repair, or review a source file using an earlier read as
its authoritative version. Reread every relevant file immediately before the
decision or edit that depends on it.

## Required checkpoints

1. **Before analysis:** reread files whose contents support the conclusion.
2. **Before editing:** reread the target file and directly related interfaces.
3. **Before repair:** reread the janitor findings and the current changed
   files. Do not repair an earlier version.
4. **Before review:** reread the original request, acceptance criteria, and
   every file or diff being reviewed.
5. **After a handoff, compaction, or user reply:** treat prior file contents as
   potentially stale and refresh only the files needed for the next action.

## When state changes

- The user's current file contents always win over an earlier plan or agent
  report.
- If the current state invalidates the assigned scope, stop editing and return
  a concise blocker to the orchestrator.
- Do not reread unrelated files just to be safe; freshness applies to the
  decision at hand.

## Handoff

Report only the files refreshed, a material drift if one exists, and the next
safe action. Do not paste file contents unless needed to explain a blocker.
