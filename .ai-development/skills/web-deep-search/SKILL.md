---
name: web-deep-search
description: Research material external facts with concise, primary-source-first web evidence. Use any available search provider only when requested or when current information changes the result.
---

# Material Web Research Protocol

## When to use web research

Use web research only when the user explicitly asks for it or when a current,
external fact materially affects the implementation or answer. Do not search
for information already available in the repository, supplied documentation,
or stable domain knowledge.

## Evidence order

1. Read local repository documentation and source first.
2. Fetch a known official URL directly when one exists.
3. Inventory the currently available and permitted web-capable tools, including
   built-in search, direct web fetches, and enabled MCP search tools.
4. Choose the best available discovery tool for the source needed. The configured
   `random` provider selects among connected OpenCode search providers and fails
   over when one is rate limited; do not bind the workflow to one provider.
5. Fetch the most relevant primary sources: official documentation,
   specifications, release notes, maintainer repositories, or issue trackers.
6. Use secondary sources only when primary evidence is unavailable, and label
   the uncertainty.

Use an enabled self-hosted or no-key search tool when it is available, but never
assume a particular provider or require one for the workflow.

## Efficient search

- Start with one targeted query, then fetch only the 1–3 useful results.
- Search again only when the first evidence is insufficient or conflicts.
- Use parallel research only for genuinely independent sources where the
  expected value justifies the added handoff cost.
- Do not use search snippets as evidence when the underlying source is
  fetchable.

## Output

Return only the conclusion, the material evidence, and any uncertainty that
affects the decision. Keep URLs and quotations minimal. Do not run builds,
tests, or shell commands as part of web research unless explicitly requested.
