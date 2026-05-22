---
name: subagent-split
description: Large multi-step task? Identify dependencies first. Split independent streams into parallel subagents. Keep dependent chains sequential in one agent. Use when the task touches 3+ files, has multiple concerns, or would need 10+ sequential tool calls.
---

# Subagent Splitting Protocol

## Decision Tree

```
Task is large (3+ files, 5+ steps, multiple concerns)?
├── YES → List all sub-tasks, identify dependencies
│   ├── Sub-tasks have NO dependencies on each other?
│   │   └── YES → Launch parallel subagents via task tool
│   └── Sub-tasks form a dependency chain (A→B→C)?
│       └── YES → Keep in one agent OR chain sequentially
└── NO → Do not split, use a single agent
```

## Dependency Map Notation

```
A, B, C        → full parallel (all independent)
A → B → C      → sequential (each depends on previous)
A → B, C       → partial: A→B sequential, C parallel to B
A → B → C      → partial: A→B→C chain, D parallel to C
  ↓
  D
```

## Rules

### Split into parallel subagents ONLY when:
- Streams touch **different files/directories** and need **none of each other's output**
- One stream is **read-only research** (never a dependency)
- Coordination overhead is worth it (3+ independent streams, or 10+ tool calls)

### Keep sequential (do NOT split) when:
- Step B reads files modified by step A
- Step B builds on A's types, schema, API surface, or result
- Step B cannot proceed without knowing A's output

## Execution

### Parallel
``` Use task tool, subagent_type: "general" (or "explore" for research).
Each subagent gets:
- self-contained prompt (all context it needs, no follow-ups needed)
- list of exact files to touch
- instruction to return summary of changes + decisions
```

### Sequential
Run as one agent, or chain: Agent1 → Agent2 (receives Agent1's output summary) → Agent3.

Do NOT launch dependent sub-tasks in parallel.

## Examples

**Parallel (all independent):** "Add dark mode toggle to React app"
- Explore (read theme/styling arch)
- Implement (CSS vars, ThemeProvider, toggle)
- Test (unit + integration)
→ Launch 3 subagents simultaneously

**Sequential (dependency chain):** "Add DB table + API endpoint + frontend"
- Do NOT split
- Run one agent: migration → model → route handler → tests
- OR chain: Agent1 (migration) → Agent2 (model + endpoint) → Agent3 (frontend)

## Template Prompt

```
You are working on one part of a larger task.

Goal: <one sentence>
Files: <path list>
Constraints: <rules to follow>
Context: <snippets, imports, conventions>

Return: summary of changes, files modified, decisions made.
```
