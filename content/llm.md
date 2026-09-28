---
title: "LLM API for Pi Agents"
description: "Blazing-fast, ultra-cheap LLM infrastructure built for Pi agents. Self-hosted Qwen3.8-Coder-27B behind a LiteLLM endpoint — GitHub sign-in, credit packs, exact cost-plus pricing."
weight: 1
hideHeader: true
---

<div class="not-prose mt-4 mb-12">
    <div class="max-w-3xl mx-auto text-center py-8">
        <p class="inline-block mb-4 px-3 py-1 rounded-full text-xs font-semibold tracking-wide text-indigo-700 bg-indigo-50 border border-indigo-100">
            api.girard-davila.net — now in beta
        </p>
        <h1 class="text-4xl md:text-6xl font-extrabold tracking-tight text-gray-900 leading-tight mb-6">
            Blazing-Fast, Ultra-Cheap LLM Infrastructure<br class="hidden md:block"/>
            <span class="text-indigo-600">Built for Pi Agents</span>
        </h1>
        <p class="text-lg md:text-xl text-gray-600 mb-8">
            A self-hosted <strong>Qwen3.8-Coder-27B</strong> on a dedicated RTX&nbsp;3090, served through a
            LiteLLM endpoint with GitHub sign-in, virtual keys, and exact
            cost-plus token pricing. No cloud markups, no queue — just fast,
            cheap completions for your agent.
        </p>
        <div class="flex flex-col sm:flex-row gap-3 justify-center">
            <a href="#join" class="px-6 py-3 rounded-lg bg-indigo-600 text-white font-semibold hover:bg-indigo-700 transition-colors shadow-sm">
                Get your key — free in beta
            </a>
            <a href="#billing" class="px-6 py-3 rounded-lg bg-white text-gray-800 font-semibold border border-gray-200 hover:border-gray-300 hover:bg-gray-50 transition-colors">
                How billing works
            </a>
        </div>
    </div>
</div>

<div class="not-prose my-12">
    <div class="rounded-xl bg-gray-900 shadow-lg overflow-hidden text-left">
        <div class="flex items-center gap-1.5 px-4 py-3 bg-gray-800">
            <span class="w-3 h-3 rounded-full bg-red-400"></span>
            <span class="w-3 h-3 rounded-full bg-yellow-400"></span>
            <span class="w-3 h-3 rounded-full bg-green-400"></span>
            <span class="ml-2 text-xs text-gray-400 font-mono">pi — litellm/qwen3.8-coder</span>
        </div>
<pre class="p-5 text-sm leading-relaxed font-mono text-gray-100 overflow-x-auto"><span class="text-gray-500">$</span> pi --model litellm/qwen3.8-coder
<span class="text-gray-400">◆ using model "litellm/qwen3.8-coder" · api.girard-davila.net</span>

&gt; summarize the git log of this repo in one line

<span class="text-indigo-300">◆</span> Last release: 42 commits — auth rework (SSO + virtual keys),
  perf: batch embeddings, docs pass. No breaking changes.
  <span class="text-gray-500">(1.2s · 384 tok · $0.0009)</span></pre>
    </div>
</div>

## Why agents on this endpoint

- **Fast where it counts.** The whole box is one model on one GPU — no shared
  cloud queue, no multi-tenant noise. Speculative (MTP) decoding on top.
- **Priced at cost.** Credit packs are billed at exact hardware/electricity
  cost-plus. There is no inference gross margin hiding in your token bill.
- **Cache-aware.** Prompt caching at the proxy layer means long,
  repetitive agent contexts stop paying full price for the prefix.
- **Yours to lose.** Self-hosted, small, and boring on purpose. Your key,
  your spend, your rate limits — all visible in the LiteLLM UI.

## How token billing works {#billing}

1. **Buy a credit pack** (Stripe) — e.g. `$5 → 500k tokens` at the pack's
   fixed rate. Packs never expire while the account is in good standing.
2. **Spend is metered per token** on your virtual key — input + output, at
   the published rate, with caching discounts applied automatically.
3. **You see everything** in the dashboard: spend per model, per key, per day.
   Hard spend caps are enforced, not advisory.

> **Beta:** while we're in beta, new accounts get free credits — no card
> required. Stripe top-ups go live with the public launch.

## Join in three steps {#join}

### 1. Create an account

Sign in with GitHub at
**<a class="text-indigo-600 underline decoration-indigo-200 underline-offset-2" href="https://api.girard-davila.net/api/llm/sso/key/generate">api.girard-davila.net</a>**.
The SSO round-trip issues your personal **virtual key** automatically —
no email verification dance, no manual key creation.

### 2. Connect Pi

```bash
pi install npm:pi-provider-litellm                  # provider + SSO support
pi install git:github.com/alx/pi-provider-girard    # the /girard preset
```

Then inside Pi:

```
/girard            # writes the endpoint into your Pi settings
/login litellm     # opens the SSO URL → browser → key stored
/model litellm/qwen3.8-coder
```

### 3. Top up (when billing launches)

Pick a credit pack at checkout; your existing key keeps working, spend
limits included. Nothing to re-install, nothing to re-authenticate.

## Honest specs

| | |
|---|---|
| Model | Qwen3.8-Coder-27B (IQ4_XS GGUF) |
| Hardware | Dedicated RTX 3090 24 GB (single tenant) |
| Context | up to 180k tokens |
| Endpoint | OpenAI-compatible · `https://api.girard-davila.net/api/llm` |
| Auth | GitHub SSO → per-user virtual keys |
| Limits | Per-key RPM and spend caps, configurable |

Questions or want a bigger key budget? <a class="text-indigo-600 underline decoration-indigo-200 underline-offset-2" href="mailto:girard.davila@gmail.com">girard.davila@gmail.com</a>.
