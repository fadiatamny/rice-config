---
name: web-deep-search
description: Research material external facts with concise, primary-source-first web evidence. Use any available search provider only when requested or when current information changes the result.
---

# Material Web Research

## When

Only when the user asks, or when a current external fact materially changes the
answer. Do not search for what the repository, supplied documentation, or stable
domain knowledge already answers.

## Evidence order

1. Local documentation and source.
2. A known official URL, fetched directly.
3. One targeted discovery query through whatever search tool is available.
4. The 1–3 most relevant primary sources: official docs, specs, release notes,
   maintainer repositories, issue trackers.
5. Secondary sources only when primary evidence is unavailable; label the
   uncertainty.

Search again only if the first evidence is insufficient or conflicts. Never treat
a snippet as evidence when the source is fetchable. Parallelize only genuinely
independent sources.

## Output

Return the conclusion, the material evidence, and any uncertainty affecting the
decision. Keep URLs and quotations minimal. Never run builds or tests for this.
