---
name: ry-image
description: "Use when the user wants an image created, edited, redesigned, or art-directed (生图、改图、海报、配图、概念图). Shape the idea with the upstream visual library, then generate only through scripts/generate.sh. The configured model is an opaque route alias; do not choose a provider or use host-native image tools."
---

# ry-image

Thin image policy for any local agent. Upstream `gpt-image` remains the vendor reference library and CLI. This skill owns intent, prompt craft, and the only execution path.

## Routing boundary

- Runtime endpoint, credential, and model alias come only from `RY_IMAGE_BASE_URL`, `RY_IMAGE_API_KEY`, and `RY_IMAGE_MODEL`.
- `RY_IMAGE_MODEL` defaults to `image`. It is an opaque alias. Do not interpret, rename, validate, or replace it.
- Do not hardcode a gateway, host, provider, or real model id.
- Do not ask the user to choose Flare, Sunburst, Image 2, Grok, or any other provider model unless they explicitly ask to select one.
- Provider field compatibility belongs to the configured gateway. Do not fork or patch the upstream CLI to strip or remap fields.

## Knowledge

Read the smallest relevant slice, not the whole library.

Creative sources, via `references/` (the upstream gallery):

- `references/gallery.md` to choose a category, then only that category file
- `references/craft.md` only for a concrete gap
- `references/templates-*.md` only when a template is the gap

Do not read provider-specific notes by default, including `references/models.md` and `references/openai-image-*`. Open them only when the user explicitly asks to target GPT Image or a named model.

Preserve the user's exact text, subject, and edit invariants. Do not silently change the brief.

## Execution

Invoke only:

```bash
scripts/generate.sh -p "PROMPT" --size 1024x1024 --quality high -f output.png
```

Use the skill directory's `scripts/generate.sh`. Do not call `gpt-image`, `skills/gpt-image/scripts/generate.py`, a host `image_generate` tool, or any other image backend.

The wrapper maps `RY_IMAGE_*` onto the upstream CLI for that child process only. It always passes `--model`. Do not pass `--model` yourself unless the user explicitly overrides the route.

Portable flags only: `-p`, `-f`, `-i`, `-m`, `--size`, `--quality`, `-n`, `--format`.

Defaults: one image, `--quality high`, and a size the user actually needs (`1024x1024` when unspecified). `xhigh` and `max` are outside this path because the upstream CLI rejects them unless the model id is a GPT Image 2.5 name. Do not switch models to unlock them.

Reference edits use repeated `-i`. Inpainting adds `-m` and requires `-i`.

If `RY_IMAGE_API_KEY` or `RY_IMAGE_BASE_URL` is missing, stop and say so. Do not fall back to `OPENAI_*`, `GPT_IMAGE_*`, host-native image tools, or another skill. Do not write secrets into the repo, a `.env`, or the chat.

## Report

Return the output path, the size and quality used, and at most one refinement suggestion. On API failure, report the failure and stop. Do not retry with a different model or a rewritten prompt.
