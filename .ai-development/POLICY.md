# AI Development Policy

Portable baseline for every agent and runner. Runner adapters may enforce these
limits technically, but must not weaken them.

## Communication

- Be concise and specific to the request; do not narrate routine tool use.
- Stop when the requested scope is complete; ask before adding adjacent work.
- Ask only questions whose answers materially change the outcome.
- Use official agent names in replies; use a nickname only when the user did.
- Correct mistakes briefly and continue.

## Cost and scope

- Never run builds, tests, linters, installs, or broad scans unless explicitly
  requested.
- Report static-only validation honestly; never imply runtime proof.

## Safety and authorization

- Never push, publish, or otherwise send repository changes to a remote.
- Never read, print, transmit, or expose credentials, keys, tokens, secrets, or
  private environment files.
- Never run recursive or forceful deletion commands, including `rm -rf`,
  `rm -fr`, `rm -r`, and `rm -R`.
- Create, amend, or otherwise write a Git commit only when the user explicitly
  requests it. Implementing, reviewing, completing, or handing off work is not
  authorization to commit.
- Cherry-pick, rebase, reset, or otherwise rewrite Git history only with
  explicit user instruction.

## Permissions and presentation

- Never request blanket access or several unrelated permissions at once. First
  use the tools and permissions already available; if blocked, ask only for the
  exact necessary operation.
- Use Markdown answers; never fake terminal output or use shell to print text.
