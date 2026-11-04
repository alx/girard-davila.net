---
title: "API Reference"
description: "OpenAI-compatible API reference for api.girard-davila.net - quickstart, authentication, chat completions, streaming, reasoning, tools, service tiers, prompt caching and error handling."
weight: 2
hideHeader: true
aliases:
  - "/docs/"
  - "/api/"
---

<div class="not-prose mt-4 mb-12">
    <div class="max-w-3xl mx-auto text-center py-8">
        <p class="inline-block mb-4 px-3 py-1 rounded-full text-xs font-semibold tracking-wide text-indigo-700 bg-indigo-50 border border-indigo-100">
            OpenAI-compatible &middot; base URL below
        </p>
        <h1 class="text-4xl md:text-5xl font-extrabold tracking-tight text-gray-900 leading-tight mb-4">
            API Reference
        </h1>
        <p class="text-lg text-gray-600 mb-6">
            One endpoint, one key, the OpenAI wire format. Bring any OpenAI SDK, agent framework or
            <code class="text-indigo-700">curl</code>.
        </p>
        <div class="max-w-xl mx-auto rounded-lg bg-gray-900 text-gray-100 px-4 py-3 font-mono text-sm text-left overflow-x-auto">
            <span class="text-gray-500">base_url</span> = https://api.girard-davila.net/api/llm/v1
        </div>
    </div>
</div>

## Quickstart {#quickstart}

Get a key from the [model catalog page](/models/) (Google sign-in, €3 free), then:

<div class="not-prose rounded-xl bg-gray-900 shadow-lg overflow-hidden text-left my-6">
<div class="flex items-center gap-1.5 px-4 py-3 bg-gray-800">
<span class="w-3 h-3 rounded-full bg-red-400"></span><span class="w-3 h-3 rounded-full bg-yellow-400"></span><span class="w-3 h-3 rounded-full bg-green-400"></span>
<span class="ml-2 text-xs text-gray-400 font-mono">shell</span>
</div>
<pre class="p-5 text-sm leading-relaxed font-mono text-gray-100 overflow-x-auto"><span class="text-gray-500">$</span> export GD_API_KEY=sk-...

<span class="text-gray-500">$</span> curl https://api.girard-davila.net/api/llm/v1/chat/completions \
    -H "Authorization: Bearer $GD_API_KEY" \
    -H "Content-Type: application/json" \
    -d '{
      "model": "deepseek-v4.1-flash",
      "messages": [{"role": "user", "content": "Say hello in one word."}]
    }'</pre>
</div>

Python (any OpenAI-compatible client works):

```python
from openai import OpenAI

client = OpenAI(
    base_url="https://api.girard-davila.net/api/llm/v1",
    api_key=os.environ["GD_API_KEY"],
)

resp = client.chat.completions.create(
    model="deepseek-v4.1-flash",
    messages=[{"role": "user", "content": "Say hello in one word."}],
)
print(resp.choices[0].message.content)
```

Node:

```js
import OpenAI from "openai";

const client = new OpenAI({
  baseURL: "https://api.girard-davila.net/api/llm/v1",
  apiKey: process.env.GD_API_KEY,
});

const resp = await client.chat.completions.create({
  model: "deepseek-v4.1-flash",
  messages: [{ role: "user", content: "Say hello in one word." }],
});
```

Ask for the model list with `GET /v1/models` — it returns only the models
**your key** can call.

## Authentication {#auth}

Every request carries your key as a bearer token:

```
Authorization: Bearer sk-...
```

- **Keys are shown once.** The full value appears exactly once, at
  creation; the dashboard afterwards shows only the first 7 characters. Store
  it in an env var or secret manager — there is no "reveal" endpoint.
- **Keys are scoped.** A key is limited to the models on the account plan and
  to a budget (€3 lifetime on the free tier). Calling a model outside the
  scope returns `403 key_model_access_denied` — an explicit refusal, never a
  silent substitution.
- **Revocation is immediate.** Rotating a key blocks the old one at the proxy,
  so a leaked key stops working on the next request — no propagation delay.
- **Never put a key in client-side code.** Calls are authenticated per
  request; call the API from your backend or your own agent process.

The dashboard at [provider.girard-davila.net](https://provider.girard-davila.net)
shows your key, its budget, live spend, and a per-model / per-service-tier
usage breakdown.

## Chat Completions {#chat}

`POST /v1/chat/completions` — the OpenAI schema. Supported request fields:

| Field | Notes |
|---|---|
| `model` | Required. A model id from `GET /v1/models`. |
| `messages` | Required. Standard `system` / `user` / `assistant` / `tool` roles. |
| `max_tokens`, `max_completion_tokens` | Cap on generated tokens. |
| `temperature`, `top_p`, `seed` | Sampling controls. `seed` is best-effort. |
| `stop` | Up to several stop sequences. |
| `stream`, `stream_options` | SSE streaming; see [Streaming](#streaming). |
| `tools`, `tool_choice`, `parallel_tool_calls` | Function calling. |
| `response_format` | Structured outputs (`{"type": "json_object"}`). |
| `reasoning_effort` | Reasoning models only; see [Reasoning](#reasoning). |
| `service_tier` | `priority` or `flex` on tagged models; see [Service tiers](#tiers). |
| `prompt_cache_key` | Group requests for prompt caching; see [Caching](#caching). |
| `frequency_penalty`, `presence_penalty`, `logit_bias`, `logprobs`, `top_logprobs`, `n` | Standard OpenAI semantics. |

Responses are the OpenAI shape: `choices[].message.content`, plus `usage` with
`prompt_tokens`, `completion_tokens` and `total_tokens`. Token counts are what
you are billed on.

## Streaming {#streaming}

Set `"stream": true` and consume server-sent events:

```python
stream = client.chat.completions.create(
    model="deepseek-v4.1-flash",
    messages=[{"role": "user", "content": "Count to five."}],
    stream=True,
)
for chunk in stream:
    if delta := chunk.choices[0].delta.content:
        print(delta, end="", flush=True)
```

The stream ends with `data: [DONE]`. Usage is reported on the final chunk when
you pass `"stream_options": {"include_usage": true}` — worth doing if you
meter your own users, since it saves a second request to learn the cost.

## Reasoning {#reasoning}

Models advertised with a **reasoning** chip accept `reasoning_effort`
(`low` / `medium` / `high`). Higher effort spends more tokens thinking before
it answers — you pay for those tokens at the output rate, so raise it only
when the task needs it (hard refactors, multi-step planning) and leave it low
for extraction, formatting and tool routing.

## Structured outputs {#structured}

```python
resp = client.chat.completions.create(
    model="deepseek-v4.1-flash",
    messages=[{"role": "user", "content": "Name three primary colours."}],
    response_format={"type": "json_object"},
)
```

JSON mode guarantees syntactically valid JSON, not a specific schema — put the
schema in the prompt and validate the result on your side. A truncated
generation can still produce invalid JSON, so always handle a parse failure.

## Service tiers {#tiers}

Models with a `tier:` chip in the [catalog](/models/) accept an optional
`service_tier` field:

```python
resp = client.chat.completions.create(
    model="deepseek-v4.1-flash",
    messages=[{"role": "user", "content": "..."}],
    service_tier="priority",   # or "flex"
)
```

| `service_tier` | You pay | Behaviour |
|---|---|---|
| *(omitted)* | the price shown in the catalog | Standard queue. |
| `"priority"` | **1.5×** the catalog price | Fast lane — lower time-to-first-token under load. |
| `"flex"` | **0.8×** the catalog price | Best-effort queue. May wait **up to 10 minutes**; if no capacity frees up in that window the request returns `429`. |

You are billed at the tier you actually used, as recorded on the request. A
request that never sends `service_tier` always bills at the standard price, and
models without the chip ignore the field entirely — sending it there changes
neither price nor queue.

Use `flex` for batch jobs, backfills and offline evaluation; use `priority`
for anything a human or an agent is waiting on. Because `flex` can fail with
`429`, wrap it in the retry loop described in [Errors and retries](#errors).

## Prompt caching {#caching}

Long, repetitive prefixes (a system prompt, a repo map, a tool catalogue) are
cached at the proxy and upstream, and cached input tokens bill at a fraction of
the input rate.

- **Keep the prefix stable.** Cache hits depend on an identical leading
  sequence — put variable content (the user's question) last.
- **`prompt_cache_key`** on supported models groups requests you know share a
  prefix, improving hit rates when you send interleaved traffic.
- **Best-effort.** Caching is not guaranteed; it is an optimisation, never
  something to depend on for correctness. Your `usage` reports cached tokens
  when a hit occurs, and the cost you are billed reflects it.

## Errors and retries {#errors}

Every error is JSON in the OpenAI shape:

```json
{"error": {"message": "...", "type": "...", "param": null, "code": "..."}}
```

| Status | `type` | Meaning | What to do |
|---|---|---|---|
| `400` | `invalid_request_error` | Malformed body, missing `messages`, or a model id that does not exist at all | Fix the request. Do not retry. |
| `403` | `key_model_access_denied` | The model exists but your key is not scoped to it | Request access, or use a model from `GET /v1/models`. Do not retry. |
| `401` | `auth_error` / `token_not_found_in_db` | Missing, malformed, revoked or unknown key | Check the header; re-issue the key if it was revoked. Do not retry. |
| `422` | `budget_exceeded` | The key's budget is exhausted. Note: **422**, not 402 or 429 | Top up. Retrying will not help. |
| `429` | `rate_limit_error` | Rate limited — or a `flex` request that found no capacity within 10 minutes | Back off and retry. |
| `5xx` | `api_error` | Upstream failure | Retry with exponential backoff. |

Retry only `429` and `5xx`, with jittered exponential backoff and a ceiling:

```python
import random, time
from openai import APIStatusError

def with_retries(fn, attempts=5):
    for i in range(attempts):
        try:
            return fn()
        except APIStatusError as e:
            if e.status_code not in (429, 500, 502, 503, 504) or i == attempts - 1:
                raise
            time.sleep(min(2 ** i, 30) * (0.5 + random.random()))
```

Do not retry `400`, `401`, `403` or `422` — they are deterministic and will fail
the same way.

## Data handling {#data}

- Request and response **content is not stored** in the billing logs — only
  metadata (model, token counts, cost, timestamps). Your dashboard's usage view
  reflects exactly that.
- Your traffic is forwarded to the upstream provider named per model in the
  catalog (DeepInfra in the US, Mistral in the EU, or our own GPU for
  self-hosted routes). The catalog's "where" column tells you which, per model.
- Keys are stored hashed; the plaintext value exists only at creation time.

## Compatibility note {#litellm}

This endpoint is a [LiteLLM](https://docs.litellm.ai) proxy, which is why the
wire format is OpenAI's. That also means you can point LiteLLM, LangChain,
LlamaIndex, the `openai` SDK, or any OpenAI-compatible agent at the base URL
above and expect the standard behaviour. Anything documented as an OpenAI
feature that is *not* listed on this page should be assumed unsupported —
ask, and it can usually be enabled.
