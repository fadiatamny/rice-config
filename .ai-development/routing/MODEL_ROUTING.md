# Delegation model routing

`models.json` records user-editable model and variant choices for six named
tiers. The `model-routing` skill describes how to use those choices when the
host provides a supported and permitted model-selection mechanism. The file
itself does not configure delegation or establish availability; loading the
skill does not guarantee a selection can be applied.

The tier names are user-defined labels, not a ranking of capability, speed, or
cost. Values do not guarantee that a model or variant exists or is accessible.

Explicit user model or tier choices take precedence. The skill requires checking
host instructions, capabilities, permissions, and availability, propagating
overrides to delegated work where supported, and reporting when a selection
cannot be applied rather than claiming success or silently substituting.
