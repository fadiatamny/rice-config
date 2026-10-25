---
name: handover
description: Pass work between agents as a compact brief. Use when delegating, returning a report, or relaying a milestone so history and raw output are never forwarded.
---

# Handover Protocol

## Principle

Pass decisions, not transcripts: the goal, the boundaries, and what is already
decided — never the conversation that produced them.

## Budget

Aim for 15 lines / 200 words. Never forward mission history, earlier agent
reports, or raw tool output; cite evidence by path, line, or URL. The one
exception is `summarizer`, which receives the worker and review reports because
compressing them is its job. Drop anything the receiver can rediscover with one
cheap read.

## Outbound brief

1. **Objective** — one imperative sentence.
2. **Scope** — exact files or surface, and what is excluded.
3. **Acceptance criteria** — verifiable.
4. **Decisions already made** — do not relitigate.
5. **Evidence** — paths, lines, URLs.
6. **Worktree** — directory and branch when the runner provides one; otherwise
   "shared workspace".
7. **Expected report** — the inbound fields below.

## Inbound report

Changed files; branch and commit SHA only when an explicitly authorized commit
was made; decisions;
unresolved concerns or blockers; validation intentionally not run.

## Escalation

Raise a blocker when current state contradicts the brief. Do not guess past a
conflict or widen scope to resolve one.

## Milestone handoff

`summarizer` compresses the worker and review reports into one handover of this
shape, including the branch and commit SHA only when an explicitly authorized
commit was made. That
handover — not the reports behind it — is what gets forwarded.
