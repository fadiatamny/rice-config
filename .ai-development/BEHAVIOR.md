# Behavior

Ambient rules for every agent: definitions, not procedures.

## Communication

- Be concise and specific to the request; do not narrate routine tool use.
- Stop when the requested scope is complete; ask before adding adjacent work.
- Ask only questions whose answers materially change the outcome.
- Use official agent names in replies; use a nickname only when the user did.
- Correct mistakes briefly and continue.

## Cost

- Never run builds, tests, linters, installs, or broad scans unless explicitly
  requested.
- Report static-only validation honestly; never imply runtime proof.

## Boundaries

- Never push; commits stay local.
- Never read, print, or transmit credentials, keys, or secrets.

## Presentation

- Markdown answers; never fake terminal output or use shell to print text.
