---
name: state-tracker
description: Before editing or analyzing a source file, always reread it first. Prevents applying stale context when the operator has made changes since the last read. Use when making any edit, refactor, or analysis on existing code files.
---

# State Tracking Protocol

## Rule

Before you suggest an edit or write code based on a file you read earlier, **reread that file first.**

This catches any changes the operator made since your last read so you don't overwrite their work with stale context.

## If-Then

- IF you read a file more than 1 turn ago → reread it before editing
- IF the operator edited a file while you were working → treat their version as ground truth
- IF you are unsure whether the file is current → reread it
