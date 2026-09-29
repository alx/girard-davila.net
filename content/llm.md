---
title: "LLM API for Pi Agents"
description: "Blazing-fast, ultra-cheap LLM infrastructure built for Pi agents. Self-hosted Qwen3.8-27B behind a LiteLLM endpoint — GitHub sign-in, credit packs, exact cost-plus pricing."
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
        <div class="flex flex-col sm:flex-row gap-3 justify-center mt-2">
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
            <span class="ml-2 text-xs text-gray-400 font-mono">pi — gd/Qwen3.8-27B-i1-IQ4_XS-GGUF-Smaller</span>
        </div>
<pre class="p-5 text-sm leading-relaxed font-mono text-gray-100 overflow-x-auto"><span class="text-gray-500">$</span> pi --model gd/Qwen3.8-27B-i1-IQ4_XS-GGUF-Smaller
<span class="text-gray-400">◆ using model "gd/Qwen3.8-27B-i1-IQ4_XS-GGUF-Smaller" · api.girard-davila.net</span>

&gt; summarize the git log of this repo in one line

<span class="text-indigo-300">◆</span> Last release: 42 commits — auth rework (SSO + virtual keys),
  perf: batch embeddings, docs pass. No breaking changes.
  <span class="text-gray-500">(1.2s · 384 tok · $0.0009)</span></pre>
    </div>
</div>

## Join in three steps {#join}

<div class="not-prose my-6">
<form id="join-form" class="max-w-md mx-auto bg-white border border-gray-200 rounded-2xl p-6 shadow-sm text-left">
<p class="text-sm text-gray-600 mb-4">Leave your details to unlock the three steps below — and get on the list when billing launches.</p>
<input type="website" name="website" tabindex="-1" autocomplete="off" class="hidden" aria-hidden="true">
<div class="mb-4"><label for="jf-name" class="block text-sm font-medium text-gray-700 mb-1">Name</label>
<input id="jf-name" name="name" type="text" autocomplete="name" required class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm"></div>
<div class="mb-4"><label for="jf-email" class="block text-sm font-medium text-gray-700 mb-1">Email</label>
<input id="jf-email" name="email" type="email" autocomplete="email" required class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm"></div>
<div class="mb-4"><label for="jf-msg" class="block text-sm font-medium text-gray-700 mb-1">What are you building? <span class="text-gray-400 font-normal">(optional)</span></label>
<input id="jf-msg" name="message" type="text" class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm"></div>
<div class="flex items-center gap-3 flex-wrap">
<button type="submit" class="px-4 py-2 rounded-lg bg-indigo-600 text-white text-sm font-semibold hover:bg-indigo-500">Unlock the steps</button>
<span id="join-status" class="text-sm text-gray-500" role="status"></span>
</div>
</form>
</div>
<p id="join-chip" class="hidden not-prose max-w-md mx-auto my-6 text-sm text-center text-indigo-700 bg-indigo-50 border border-indigo-100 rounded-full px-4 py-2">You are on the list — steps unlocked below. <button id="join-reset" class="underline">not you?</button></p>

<div id="join-steps" hidden>
<h3>1. Create an account</h3>
<p>Sign in with GitHub at <a class="text-indigo-600 underline decoration-indigo-200 underline-offset-2" href="https://api.girard-davila.net/api/llm/sso/key/generate">api.girard-davila.net</a>. The SSO round-trip issues your personal <strong>virtual key</strong> automatically — no email verification dance, no manual key creation.</p>
<h3>2. Connect Pi</h3>
<pre><code>pi install npm:pi-provider-litellm                  # provider + SSO support
pi install git:github.com/alx/pi-provider-gd        # the /gd-register preset</code></pre>
<p>Then inside Pi:</p>
<pre><code>/gd-register     # registers the endpoint + prints your connect steps
/model gd/Qwen3.8-27B-i1-IQ4_XS-GGUF-Smaller</code></pre>
<h3>3. Top up (when billing launches)</h3>
<p>Pick a credit pack at checkout; your existing key keeps working, spend limits included. Nothing to re-install, nothing to re-authenticate.</p>
</div>

<script>
(function(){
var K="girard_llm_joined",E="https://formspree.io/p/3100741512619621923/f/joinLlm";
var steps=document.getElementById("join-steps"),form=document.getElementById("join-form"),
chip=document.getElementById("join-chip"),status=document.getElementById("join-status"),
reset=document.getElementById("join-reset"),wrap=form?form.parentElement:null;
function unlocked(){steps.hidden=false;if(chip)chip.classList.remove("hidden");if(wrap)wrap.style.display="none";}
function locked(){steps.hidden=true;if(chip)chip.classList.add("hidden");if(wrap)wrap.style.display="";}
try{if(localStorage.getItem(K))unlocked();}catch(e){}
if(reset)reset.onclick=function(){try{localStorage.removeItem(K);}catch(e){}locked();};
if(!form)return;
form.onsubmit=async function(ev){
ev.preventDefault();
var el=form.elements,n=el["name"].value.trim(),em=el["email"].value.trim(),ms=el["message"].value.trim();
if(!n||!em){status.textContent="Name and email are required.";return;}
status.textContent="Sending…";
try{
var r=await fetch(E,{method:"POST",mode:"cors",headers:{"Content-Type":"application/json","Accept":"application/json","Formspree-Client":"girard-landing"},body:JSON.stringify({name:n,email:em,message:ms,_replyto:em})});
var d={};try{d=await r.json();}catch(e2){}
if(r.ok&&d.ok){try{localStorage.setItem(K,"1");}catch(e2){}status.textContent="You are in.";unlocked();}
else{status.textContent=(d&&(d.message||d.error))||"Something went wrong, please try again.";}
}catch(e2){status.textContent="Network error — please try again.";}
};
})();
</script>

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
## Honest specs

| | |
|---|---|
| Model | `Qwen3.8-27B-i1-IQ4_XS-GGUF-Smaller` (IQ4_XS GGUF) |
| Hardware | Dedicated RTX 3090 24 GB (single tenant) |
| Context | up to 180k tokens |
| Endpoint | OpenAI-compatible · `https://api.girard-davila.net/api/llm` |
| Auth | GitHub SSO → per-user virtual keys |
| Limits | Per-key RPM and spend caps, configurable |

Questions or want a bigger key budget? <a class="text-indigo-600 underline decoration-indigo-200 underline-offset-2" href="mailto:girard.davila@gmail.com">girard.davila@gmail.com</a>.
