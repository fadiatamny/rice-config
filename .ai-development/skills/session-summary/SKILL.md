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

### Read-only usage retrieval

For every session or work summary and every usage request, actually retrieve
the available read-only records;
discovery or conversation history alone is not a substitute when access works.
Use native tools first when they provide the needed evidence, then the host's
supported read-only API. Do not claim access is guaranteed or bypass permissions.

For OpenCode, obtain the current session ID from the host-provided session
context (such as `OPENCODE_SESSION_ID`) unless another session was requested.
For each in-scope session, retrieve its usage with
`opencode api get /api/session/{id}` and its assistant message records with
`opencode api get /api/session/{id}/message`. Discover children with
`opencode api get '/api/session?parentID={id}'`, recursively for every child.
Follow response `data` and pagination cursors until exhausted for both messages
and child sessions; use the API's supported cursor parameters rather than
guessing them. Keep session and message IDs to prevent revisiting or counting
records twice. Filter by the requested time range where records support it.

Only aggregate complete, identifiable, non-overlapping usage records. Treat
unfinished messages or records with missing usage as incomplete, not zero;
report partial coverage rather than a complete total. Do not add session
usage to its message components or combine parent and child usage unless
coverage is known to be disjoint.

If the session ID, API, pagination, or any records are unavailable or access is
denied, use whatever supported read-only evidence is accessible and state
which retrieval or coverage failed. Never fabricate usage or request broader
access merely to fill gaps. Retrieve and expose only the minimum metadata and
usage needed; do not disclose prompts, message contents, credentials, secrets,
or unrelated private data.

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
