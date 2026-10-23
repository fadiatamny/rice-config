---
name: subagent-split
description: Decompose coding missions into minimal, safe agent handoffs. Parallelize only independent work and require review after implementation.
---

# Mission Decomposition Protocol

## 1. Decompose before dispatch

For an implementation request, produce a compact task map with:

- acceptance criteria and constraints;
- task dependencies;
- each task's files or surface area;
- whether current external information materially affects it; and
- whether native worktree support exists and is justified, or a shared workspace
  is safer.

Do not dispatch work until ambiguity that changes the outcome is resolved with
the user.

## 2. Parallelize only when safe

Parallel tasks must have no dependency and no overlapping files, generated
outputs, shared configuration, or integration contract. Use an isolated
worktree only when all native worktree tools are available and it reduces a real
conflict risk; it is never required. Never emulate worktrees through shell.

Use a shared workspace only for disjoint, low-conflict tasks. Keep dependent
work sequential. Do not split trivial work when delegation costs more context
than it saves.

## 3. Keep handoffs small

Give every worker only:

- one precise objective;
- relevant acceptance criteria and constraints;
- exact files or owned surface area;
- required prior decisions; and
- the expected concise report.

Do not copy the full mission history or unrelated tool output into a handoff.

## 4. Merge and verify

For a native worktree task, require exactly one local WIP commit and integrate
that commit without pushing it. If parallel work collides, stop the merge,
refresh the current state, redefine ownership, and dispatch only the required
reconciliation work.

After successful integration and review, remove every clean worktree created
for the mission using the native tool. Never force-remove a worktree. Preserve
one while it contains unresolved work or the user asks to keep it.

Always send the assembled result to the janitor. The janitor may apply clear,
low-risk, in-scope fixes; material or uncertain issues remain findings. On the
first failed review, dispatch one focused repair and rerun the janitor. If that
review also fails, stop and ask the user how to proceed.

## 5. Validation policy

Do not run builds, tests, linters, installs, benchmarks, or other expensive
commands unless the user explicitly requests them. Review is static unless the
user has requested runtime validation.
