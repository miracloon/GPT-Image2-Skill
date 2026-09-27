---
name: ry-image
description: "Use when the user wants an image created, edited, redesigned, art-directed, or reverse-prompted from a reference image (生图、改图、海报、配图、概念图、反推提示词). Generate and edit only through scripts/generate.sh. Reverse prompts only through prompt-from-image/. The configured model is an opaque route alias; do not choose a provider or use host-native image tools."
---

# ry-image

Thin image policy for any local agent. This is the only agent entry for image work. Upstream `gpt-image` and `get-prompt-from-image` stay vendor-owned libraries. This skill owns routing, intent, and the generation path.

## Route

- Create, edit, redesign, or art-direct → Generate / Edit below.
- Recreate, imitate, reverse-engineer, or extract a prompt from a user-provided image → Reverse Prompt below.
- Do not use either path for OCR or an ordinary image description.
- Do not load `gpt-image` or `get-prompt-from-image` as agent skills. Read them only through the links in this directory.

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

## Reverse Prompt

Follow `prompt-from-image/SKILL.md` and only the references it selects. That directory is the live upstream skill, not a copy. Do not duplicate or rewrite it.

Reverse prompting returns text. Do not call `scripts/generate.sh`, and do not require `RY_IMAGE_*`, unless the user also asks to generate from the result.

## Execution

Invoke only:

```bash
scripts/generate.sh -p "PROMPT" --size 1024x1024 -f output.png
```

Use the skill directory's `scripts/generate.sh`. Do not call `gpt-image`, `skills/gpt-image/scripts/generate.py`, a host `image_generate` tool, or any other image backend.

The wrapper maps `RY_IMAGE_*` onto the upstream CLI for that child process only. It always passes `--model`. Do not pass `--model` yourself unless the user explicitly overrides the route. Do not change the wrapper to strip or remap fields.

Portable flags only: `-p`, `-f`, `-i`, `-m`, `--size`, `--quality`, `-n`, `--format`.

Defaults: one image, and a size the user actually needs (`1024x1024` when unspecified). Do not pass `--quality`. Treat “higher quality”, drafts, and finals as visual intent in the prompt: detail, composition, type, material, consistency, and references. Pass `--quality` only when the user explicitly asks for that parameter. Leave the upstream CLI default alone; the gateway decides whether to keep, rewrite, or drop it. Do not add `RY_IMAGE_QUALITY`, `--quality auto`, or any other quality compatibility layer.

Reference edits use repeated `-i`. Inpainting adds `-m` and requires `-i`.

If `RY_IMAGE_API_KEY` or `RY_IMAGE_BASE_URL` is missing, stop and say so. Do not fall back to `OPENAI_*`, `GPT_IMAGE_*`, host-native image tools, or another skill. Do not write secrets into the repo, a `.env`, or the chat.

## Report

Return the output path, the size used, and at most one refinement suggestion. On API failure, report the failure and stop. Do not retry with a different model or a rewritten prompt.
