---
name: model-routing
description: Select a configured model tier for a task when the current host supports and permits model selection.
---

# Model routing

Use when selecting a model for work or when the user requests a model or tier.
Read `~/.ai-development/routing/models.json` for the current mappings of `low`,
`medium`, `high`, `extra`, `ultra`, and `quick`; do not hard-code or change them. Treat
the tier names as user-defined routing labels, not evidence of comparative
model capability, cost, or speed.

Choose a tier appropriate to the task's complexity and risk when no explicit
choice applies. An explicit user model or tier overrides that choice; resolve
an explicit tier through the current mapping. Respect the scope of an override
and pass it to delegated work where applicable and supported. Do not silently
replace an explicit choice with a different one.

First identify the current host and inspect its available model discovery and
selection capabilities, permissions, and tool instructions. Use only a
documented, permitted selection mechanism and check the chosen model and
variant against supported availability where possible. A tool's own
restrictions take precedence: for example, do not set a model argument reserved
for explicit user requests merely because this skill selected a tier. Do not
guess tool names, identifiers, variants, or unsupported parameters, and do not
bypass restrictions through another interface.

If the mapping is missing or invalid, availability cannot be established when
required, or the host cannot apply the choice, report the relevant routing or
selection as unavailable. Continue without asserting that the model was
selected only when that is compatible with the user's request and host
instructions; otherwise ask the user how to proceed. Do not claim an override
was applied without evidence. Do not create scripts, plugins, or agent profiles
to implement routing.
