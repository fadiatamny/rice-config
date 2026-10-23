---
name: development-pipeline
description: The development pipeline for any implementation request. Load before acting; covers analysis, minimal delegation, review, one repair cycle, and a compact handoff.
---

# Development Pipeline

1. Read the request and applicable project instructions.
2. Resolve straightforward facts directly with local and web tools. Dispatch
   `explorer` only when focused independent research or fresh context will
   materially improve the decision; use its compact findings in the task map.
3. Classify the implementation. Use `architect` only when acceptance criteria,
   design, dependencies, or risk need refinement: ambiguous outcomes,
   cross-cutting changes, API/schema/data contracts, multiple dependent tasks,
   or material safety risk. Otherwise define the compact acceptance criteria and
   task boundaries directly. Ask the user only material unresolved questions.
4. For a tiny, unambiguous, low-risk change, implement directly and review the
   resulting diff. Otherwise build a compact task map: acceptance criteria,
   dependencies, each task's files, whether external information matters, and
   whether a worktree is justified.
5. Parallelize only tasks with no dependency, no overlapping files, no shared
   configuration, and no integration contract. Never split work whose delegation
   costs more context than it saves.
6. Use a worktree only if the runner exposes the native worktree tools; never
   emulate one through shell. Create it and pass its directory and branch in the
   worker's brief; the worker moves its own session with `session_move` before
   editing. Never move the orchestrator's own session. Keep work sequential
   otherwise.
7. Dispatch each `developer` with a `handover` brief. A worktree worker makes one
   local WIP commit on its worktree branch and reports the branch, commit SHA,
   and worktree directory. Never push.
8. After implementation, use `janitor` only when independent review materially
   reduces risk: behavioral or multi-file changes, permissions/configuration,
   parallel work, risky changes, or nontrivial Developer work. For a trivial,
   obvious, contained change, review the diff directly instead.
9. If `janitor` fails, dispatch one focused repair and rerun `janitor`. On a
   second failure, stop and ask the user.
10. After a clean review, remove every agent-created worktree with the native
    tool. Never force-remove; preserve unresolved work.
11. Use `summarizer` only for a meaningful completed mission or milestone; send
    it the reports and present its milestone handover.

If parallel work collides, stop the merge, refresh state, redefine ownership, and
dispatch only the reconciliation work.

Request compaction only at a milestone the user identifies; never automatically.
