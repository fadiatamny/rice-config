---
name: session-summary
description: Summarize a session or work, or report session, model, or token usage using the current environment's available evidence.
---

# Session summary

Use when asked for a session or work summary, or for session, model, or token
usage. Adapt the report to the request.
Honor an explicitly requested session or time range; otherwise use the current
session, including its related subagent work. Do not treat an unrelated summary
of an external document as a request for a session report.

## Gather evidence

- Identify the current host and discover its available native session, message,
  subagent, and usage tools or supported read-only API. Follow the host's tool
  instructions and permissions; do not assume a particular API or schema.
  Use available conversation history and accessible records as appropriate.
  Do not create custom scripts or perform state-changing API calls; avoid
  credentials, secrets, and unrelated private content.
- Usage is not necessarily exposed by the runtime. If a supported tool or
  accessible record cannot supply the requested history or usage, continue with
  available evidence and say what is missing.
- Follow evidenced parent-child relationships, including nested subagents and
  resumed sessions. Identify sessions and attempts by their recorded IDs when
  available; distinguish a resumed session from a new child and avoid counting
  the same session or message twice. Do not infer an agent, model, or usage
  from a task name or an unverified relationship.

## Report

1. **Completed tasks:** State verified results, separating incomplete or
   unverified work from completed work.
2. **Decisions:** List consequential decisions and unresolved concerns.
3. **Subagents:** For each evidenced subagent, give its role or name, work and
   outcome; show parentage for nested agents and note resumptions. If the
   history is incomplete, say so rather than claiming the list is exhaustive.
4. **Recorded usage:** For each operation with available records, identify the
   operation, agent/session, recorded model, and token counts by reported
   category. Label missing fields as unavailable, not zero. Include source or
   scope sufficient to distinguish each record. An operation may span multiple
   model calls; aggregate only identifiable, non-overlapping call records and
   label the aggregation. Otherwise show the records separately or mark the
   operation-level usage unavailable.

Clearly label cumulative session totals as cumulative, including their session
and coverage; they are not per-operation usage. Do not add cumulative snapshots
to each other or to their component records, and do not combine parent and
child totals unless their coverage is known to be disjoint. Deduplicate
replayed or resumed records by stable identifiers when possible; if overlap
cannot be resolved, report the separate figures with a caveat instead of a
combined total. Preserve reported input, output, cache, and other categories
without assuming whether they overlap or deriving a total from ambiguous
categories. Never estimate missing usage, models, or costs.

Be concise, cite the evidence source where useful, and explicitly flag
unavailable or partial history and usage. Do not claim a complete accounting
when the evidence does not support one.
