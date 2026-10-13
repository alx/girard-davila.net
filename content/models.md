---
title: "Models API for Pi Agents"
description: "Blazing-fast, ultra-cheap LLM infrastructure built for Pi agents. A curated fleet of DeepInfra models plus self-hosted GPUs — Google sign-in, credit packs, transparent per-token pricing."
weight: 1
hideHeader: true
aliases:
  - "/llm/"
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
            <a href="#models" class="px-6 py-3 rounded-lg bg-white text-gray-800 font-semibold border border-gray-200 hover:border-gray-300 hover:bg-gray-50 transition-colors">
                Browse the models
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
            <span class="ml-2 text-xs text-gray-400 font-mono">pi — gd/deepseek-v4.1-flash</span>
        </div>
<pre class="p-5 text-sm leading-relaxed font-mono text-gray-100 overflow-x-auto"><span class="text-gray-500">$</span> pi --model gd/deepseek-v4.1-flash
<span class="text-gray-400">◆ using model "gd/deepseek-v4.1-flash" · api.girard-davila.net</span>

&gt; summarize the git log of this repo in one line

<span class="text-indigo-300">◆</span> Last release: 42 commits — auth rework (SSO + virtual keys),
  perf: batch embeddings, docs pass. No breaking changes.
  <span class="text-gray-500">(1.2s · 384 tok · $0.0009)</span></pre>
    </div>
</div>

## Why agents on this endpoint

- **Fast where it counts.** Self-hosted routes are one model on a dedicated GPU — no shared queue, no multi-tenant noise, MTP speculative decoding on top. Cloud routes go straight to DeepInfra's fastest inference tier.
- **Honest pricing.** The price in the catalog is the price you're billed — no struck-through list prices, no fine-print margin. Self-hosted routes are at hardware cost-plus.
- **Cache-aware.** Prompt caching at the proxy layer means long, repetitive agent contexts stop paying full price for the prefix.
- **Yours to lose.** Self-hosted, small, and boring on purpose. Your key, your spend, your rate limits — all visible in the dashboard.
- **Talk to the human.** One person runs this infrastructure. Want to explore ideas, shape what comes next, or help keep the infra maintained? Reach Alexandre Girard directly — <a class="text-indigo-600 underline decoration-indigo-200 underline-offset-2" href="https://alexgirard.com">alexgirard.com</a>.

## Join in three steps {#join}

<div id="join-steps">
<h3>1. Create an account</h3>
<p>Sign in with Google at <a class="text-indigo-600 underline decoration-indigo-200 underline-offset-2" href="https://api.girard-davila.net/api/llm/sso/key/generate">api.girard-davila.net</a>. The SSO round-trip issues your personal <strong>virtual key</strong> automatically — no email verification dance, no manual key creation.</p>
<h3>2. Connect Pi</h3>
<pre><code>pi install git:github.com/alx/pi-provider-gd</code></pre>
<p>Then inside Pi:</p>
<pre><code>/login gd    # opens the browser → Google sign-in → key stored for you
/model gd/deepseek-v4.1-flash</code></pre>
<h3>3. Top up (when billing launches)</h3>
<p>Pick a credit pack at checkout; your existing key keeps working, spend limits included. Nothing to re-install, nothing to re-authenticate.</p>
</div>

<div class="not-prose my-6">
<form id="join-form" class="max-w-md mx-auto bg-white border border-gray-200 rounded-2xl p-6 shadow-sm text-left">
<p class="text-sm text-gray-600 mb-4">Get on the list and we'll email you when billing launches.</p>
<input type="website" name="website" tabindex="-1" autocomplete="off" class="hidden" aria-hidden="true">
<div class="mb-4"><label for="jf-name" class="block text-sm font-medium text-gray-700 mb-1">Name</label>
<input id="jf-name" name="name" type="text" autocomplete="name" required class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm"></div>
<div class="mb-4"><label for="jf-email" class="block text-sm font-medium text-gray-700 mb-1">Email</label>
<input id="jf-email" name="email" type="email" autocomplete="email" required class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm"></div>
<div class="mb-4"><label for="jf-msg" class="block text-sm font-medium text-gray-700 mb-1">What are you building? <span class="text-gray-400 font-normal">(optional)</span></label>
<input id="jf-msg" name="message" type="text" class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm"></div>
<div class="flex items-center gap-3 flex-wrap">
<button type="submit" class="px-4 py-2 rounded-lg bg-indigo-600 text-white text-sm font-semibold hover:bg-indigo-500">Join the list</button>
<span id="join-status" class="text-sm text-gray-500" role="status"></span>
</div>
</form>
</div>
<p id="join-chip" class="hidden not-prose max-w-md mx-auto my-6 text-sm text-center text-indigo-700 bg-indigo-50 border border-indigo-100 rounded-full px-4 py-2">You are on the list. <button id="join-reset" class="underline">not you?</button></p>

<script>
(function(){
var K="girard_llm_joined",E="https://formspree.io/p/3100741512619621923/f/joinLlm";
var form=document.getElementById("join-form"),chip=document.getElementById("join-chip"),
status=document.getElementById("join-status"),reset=document.getElementById("join-reset"),
wrap=form?form.parentElement:null;
function unlocked(){if(chip)chip.classList.remove("hidden");if(wrap)wrap.style.display="none";}
function locked(){if(chip)chip.classList.add("hidden");if(wrap)wrap.style.display="";}
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

## Model catalog {#models}

<!-- MODEL-CATALOG:BEGIN — auto-generated by deepinfra/sync_catalog.py; do not edit between markers -->
<h3 class="mt-8 mb-2">Budget <span class="text-sm font-normal text-gray-500">— High-volume agent loops, drafts, tool calls</span></h3>
<div class="not-prose my-4 overflow-x-auto">
<table class="w-full text-sm table-fixed">
<thead>
<tr class="text-left text-xs uppercase tracking-wide text-gray-500 border-b border-gray-200">
<th class="py-2 pr-4 w-[40%]">Model</th>
<th class="py-2 pr-4 w-[10%] text-right">Context</th>
<th class="py-2 pr-4 w-[11%] text-right">Input $/1M</th>
<th class="py-2 pr-4 w-[11%] text-right">Output $/1M</th>
<th class="py-2 w-[28%]">Features</th>
</tr>
</thead>
<tbody>
<tr class="border-b border-gray-100 align-top">
<td class="py-3 pr-4 w-[40%]"><code class="text-indigo-700">llama-3.1-8b-turbo</code><div class="text-xs text-gray-500 mt-1">Tiny, instant, dirt-cheap. Summaries, classification, high-volume agent loops.</div></td>
<td class="py-3 pr-4 text-right whitespace-nowrap">131K</td>
<td class="py-3 pr-4 text-right whitespace-nowrap"><strong>0.024</strong></td>
<td class="py-3 pr-4 text-right whitespace-nowrap"><strong>0.048</strong></td>
<td class="py-3"></td>
</tr>
<tr class="border-b border-gray-100 align-top">
<td class="py-3 pr-4 w-[40%]"><code class="text-indigo-700">gpt-oss-20b</code><div class="text-xs text-gray-500 mt-1">OpenAI's open-weight MoE (3.6B active) with reasoning. Fast answers on a budget.</div></td>
<td class="py-3 pr-4 text-right whitespace-nowrap">131K</td>
<td class="py-3 pr-4 text-right whitespace-nowrap"><strong>0.036</strong></td>
<td class="py-3 pr-4 text-right whitespace-nowrap"><strong>0.168</strong></td>
<td class="py-3"><span class="inline-block mr-2 px-2 py-0.5 rounded-full text-xs font-medium text-gray-600 bg-gray-100 border border-gray-200">reasoning</span></td>
</tr>
<tr class="border-b border-gray-100 align-top">
<td class="py-3 pr-4 w-[40%]"><code class="text-indigo-700">ling-3.0-flash</code><div class="text-xs text-gray-500 mt-1">Token-efficient agentic model tuned for low-latency tool-calling workloads.</div></td>
<td class="py-3 pr-4 text-right whitespace-nowrap">131K</td>
<td class="py-3 pr-4 text-right whitespace-nowrap"><strong>0.072</strong></td>
<td class="py-3 pr-4 text-right whitespace-nowrap"><strong>0.216</strong></td>
<td class="py-3"><span class="inline-block mr-2 px-2 py-0.5 rounded-full text-xs font-medium text-gray-600 bg-gray-100 border border-gray-200">prompt cache</span><span class="inline-block mr-2 px-2 py-0.5 rounded-full text-xs font-medium text-gray-600 bg-gray-100 border border-gray-200">reasoning</span></td>
</tr>
<tr class="border-b border-gray-100 align-top">
<td class="py-3 pr-4 w-[40%]"><code class="text-indigo-700">gemma-3-27b-it</code><div class="text-xs text-gray-500 mt-1">Google Gemma 3 27B with vision. Light multimodal work at commodity prices.</div></td>
<td class="py-3 pr-4 text-right whitespace-nowrap">131K</td>
<td class="py-3 pr-4 text-right whitespace-nowrap"><strong>0.096</strong></td>
<td class="py-3 pr-4 text-right whitespace-nowrap"><strong>0.192</strong></td>
<td class="py-3"><span class="inline-block mr-2 px-2 py-0.5 rounded-full text-xs font-medium text-gray-600 bg-gray-100 border border-gray-200">vision</span></td>
</tr>
</tbody>
</table>
</div>
<h3 class="mt-8 mb-2">Mid <span class="text-sm font-normal text-gray-500">— Everyday coding and reasoning work</span></h3>
<div class="not-prose my-4 overflow-x-auto">
<table class="w-full text-sm table-fixed">
<thead>
<tr class="text-left text-xs uppercase tracking-wide text-gray-500 border-b border-gray-200">
<th class="py-2 pr-4 w-[40%]">Model</th>
<th class="py-2 pr-4 w-[10%] text-right">Context</th>
<th class="py-2 pr-4 w-[11%] text-right">Input $/1M</th>
<th class="py-2 pr-4 w-[11%] text-right">Output $/1M</th>
<th class="py-2 w-[28%]">Features</th>
</tr>
</thead>
<tbody>
<tr class="border-b border-gray-100 align-top">
<td class="py-3 pr-4 w-[40%]"><code class="text-indigo-700">gpt-oss-120b</code><div class="text-xs text-gray-500 mt-1">117B OpenAI MoE (5.1B active), high reasoning for the price. Workhorse for agent steps.</div></td>
<td class="py-3 pr-4 text-right whitespace-nowrap">131K</td>
<td class="py-3 pr-4 text-right whitespace-nowrap"><strong>0.0444</strong></td>
<td class="py-3 pr-4 text-right whitespace-nowrap"><strong>0.204</strong></td>
<td class="py-3"><span class="inline-block mr-2 px-2 py-0.5 rounded-full text-xs font-medium text-gray-600 bg-gray-100 border border-gray-200">reasoning</span></td>
</tr>
<tr class="border-b border-gray-100 align-top">
<td class="py-3 pr-4 w-[40%]"><code class="text-indigo-700">deepseek-v4-flash</code><div class="text-xs text-gray-500 mt-1">DeepSeek 284B MoE (13B active), 1M context. Fast, strong reasoning, long agentic sessions.</div></td>
<td class="py-3 pr-4 text-right whitespace-nowrap">1M</td>
<td class="py-3 pr-4 text-right whitespace-nowrap"><strong>0.108</strong></td>
<td class="py-3 pr-4 text-right whitespace-nowrap"><strong>0.216</strong></td>
<td class="py-3"><span class="inline-block mr-2 px-2 py-0.5 rounded-full text-xs font-medium text-gray-600 bg-gray-100 border border-gray-200">prompt cache</span><span class="inline-block mr-2 px-2 py-0.5 rounded-full text-xs font-medium text-gray-600 bg-gray-100 border border-gray-200">reasoning</span></td>
</tr>
<tr class="border-b border-gray-100 align-top">
<td class="py-3 pr-4 w-[40%]"><code class="text-indigo-700">glm-5.3-flash</code><div class="text-xs text-gray-500 mt-1">Z.ai multimodal flash: efficient coding + long-horizon agent tasks, 1M context, prompt cache.</div></td>
<td class="py-3 pr-4 text-right whitespace-nowrap">1M</td>
<td class="py-3 pr-4 text-right whitespace-nowrap">0.18</td>
<td class="py-3 pr-4 text-right whitespace-nowrap">0.6</td>
<td class="py-3"><span class="inline-block mr-2 px-2 py-0.5 rounded-full text-xs font-medium text-gray-600 bg-gray-100 border border-gray-200">vision</span><span class="inline-block mr-2 px-2 py-0.5 rounded-full text-xs font-medium text-gray-600 bg-gray-100 border border-gray-200">prompt cache</span><span class="inline-block mr-2 px-2 py-0.5 rounded-full text-xs font-medium text-gray-600 bg-gray-100 border border-gray-200">reasoning</span></td>
</tr>
</tbody>
</table>
</div>
<h3 class="mt-8 mb-2">Flagship <span class="text-sm font-normal text-gray-500">— Hard problems, long agentic sessions</span></h3>
<div class="not-prose my-4 overflow-x-auto">
<table class="w-full text-sm table-fixed">
<thead>
<tr class="text-left text-xs uppercase tracking-wide text-gray-500 border-b border-gray-200">
<th class="py-2 pr-4 w-[40%]">Model</th>
<th class="py-2 pr-4 w-[10%] text-right">Context</th>
<th class="py-2 pr-4 w-[11%] text-right">Input $/1M</th>
<th class="py-2 pr-4 w-[11%] text-right">Output $/1M</th>
<th class="py-2 w-[28%]">Features</th>
</tr>
</thead>
<tbody>
<tr class="border-b border-gray-100 align-top">
<td class="py-3 pr-4 w-[40%]"><code class="text-indigo-700">gemini-2.5-flash</code><div class="text-xs text-gray-500 mt-1">Google thinking model, 1M context, vision. Complex problems with structured reasoning.</div></td>
<td class="py-3 pr-4 text-right whitespace-nowrap">1M</td>
<td class="py-3 pr-4 text-right whitespace-nowrap">0.36</td>
<td class="py-3 pr-4 text-right whitespace-nowrap">3</td>
<td class="py-3"><span class="inline-block mr-2 px-2 py-0.5 rounded-full text-xs font-medium text-gray-600 bg-gray-100 border border-gray-200">vision</span><span class="inline-block mr-2 px-2 py-0.5 rounded-full text-xs font-medium text-gray-600 bg-gray-100 border border-gray-200">reasoning</span></td>
</tr>
<tr class="border-b border-gray-100 align-top">
<td class="py-3 pr-4 w-[40%]"><code class="text-indigo-700">deepseek-v4.1-flash</code><div class="text-xs text-gray-500 mt-1">DeepSeek 552B MoE, 1M context, vision + reasoning. The all-round flagship.</div></td>
<td class="py-3 pr-4 text-right whitespace-nowrap">1M</td>
<td class="py-3 pr-4 text-right whitespace-nowrap">0.24</td>
<td class="py-3 pr-4 text-right whitespace-nowrap">0.72</td>
<td class="py-3"><span class="inline-block mr-2 px-2 py-0.5 rounded-full text-xs font-medium text-gray-600 bg-gray-100 border border-gray-200">vision</span><span class="inline-block mr-2 px-2 py-0.5 rounded-full text-xs font-medium text-gray-600 bg-gray-100 border border-gray-200">prompt cache</span><span class="inline-block mr-2 px-2 py-0.5 rounded-full text-xs font-medium text-gray-600 bg-gray-100 border border-gray-200">reasoning</span></td>
</tr>
<tr class="border-b border-gray-100 align-top">
<td class="py-3 pr-4 w-[40%]"><code class="text-indigo-700">qwen3.5-27b</code><div class="text-xs text-gray-500 mt-1">Largest dense Qwen3.5: near-frontier reasoning and coding, 262K context, vision.</div></td>
<td class="py-3 pr-4 text-right whitespace-nowrap">262K</td>
<td class="py-3 pr-4 text-right whitespace-nowrap">0.312</td>
<td class="py-3 pr-4 text-right whitespace-nowrap">3.12</td>
<td class="py-3"><span class="inline-block mr-2 px-2 py-0.5 rounded-full text-xs font-medium text-gray-600 bg-gray-100 border border-gray-200">vision</span><span class="inline-block mr-2 px-2 py-0.5 rounded-full text-xs font-medium text-gray-600 bg-gray-100 border border-gray-200">reasoning</span></td>
</tr>
<tr class="border-b border-gray-100 align-top">
<td class="py-3 pr-4 w-[40%]"><code class="text-indigo-700">kimi-k2.6</code><div class="text-xs text-gray-500 mt-1">Moonshot agentic flagship: long-horizon coding, autonomous execution, swarm tasks.</div></td>
<td class="py-3 pr-4 text-right whitespace-nowrap">262K</td>
<td class="py-3 pr-4 text-right whitespace-nowrap">0.9</td>
<td class="py-3 pr-4 text-right whitespace-nowrap">4.2</td>
<td class="py-3"><span class="inline-block mr-2 px-2 py-0.5 rounded-full text-xs font-medium text-gray-600 bg-gray-100 border border-gray-200">vision</span><span class="inline-block mr-2 px-2 py-0.5 rounded-full text-xs font-medium text-gray-600 bg-gray-100 border border-gray-200">prompt cache</span><span class="inline-block mr-2 px-2 py-0.5 rounded-full text-xs font-medium text-gray-600 bg-gray-100 border border-gray-200">reasoning</span></td>
</tr>
</tbody>
</table>
</div>
<h3 class="mt-8 mb-2">Coding <span class="text-sm font-normal text-gray-500">— Agentic code generation</span></h3>
<div class="not-prose my-4 overflow-x-auto">
<table class="w-full text-sm table-fixed">
<thead>
<tr class="text-left text-xs uppercase tracking-wide text-gray-500 border-b border-gray-200">
<th class="py-2 pr-4 w-[40%]">Model</th>
<th class="py-2 pr-4 w-[10%] text-right">Context</th>
<th class="py-2 pr-4 w-[11%] text-right">Input $/1M</th>
<th class="py-2 pr-4 w-[11%] text-right">Output $/1M</th>
<th class="py-2 w-[28%]">Features</th>
</tr>
</thead>
<tbody>
<tr class="border-b border-gray-100 align-top">
<td class="py-3 pr-4 w-[40%]"><code class="text-indigo-700">qwen3-coder-480b</code><div class="text-xs text-gray-500 mt-1">480B MoE (35B active) agentic coder: SWE-bench class coding, browser-use, 262K context.</div></td>
<td class="py-3 pr-4 text-right whitespace-nowrap">262K</td>
<td class="py-3 pr-4 text-right whitespace-nowrap">0.36</td>
<td class="py-3 pr-4 text-right whitespace-nowrap">1.2</td>
<td class="py-3"><span class="inline-block mr-2 px-2 py-0.5 rounded-full text-xs font-medium text-gray-600 bg-gray-100 border border-gray-200">prompt cache</span></td>
</tr>
</tbody>
</table>
</div>
<h3 class="mt-8 mb-2">Self-hosted (beta) <span class="text-sm font-normal text-gray-500">— Our own GPUs — contact for access</span></h3>
<div class="not-prose my-4 overflow-x-auto">
<table class="w-full text-sm table-fixed">
<thead>
<tr class="text-left text-xs uppercase tracking-wide text-gray-500 border-b border-gray-200">
<th class="py-2 pr-4 w-[40%]">Model</th>
<th class="py-2 pr-4 w-[10%] text-right">Context</th>
<th class="py-2 pr-4 w-[11%] text-right">Input $/1M</th>
<th class="py-2 pr-4 w-[11%] text-right">Output $/1M</th>
<th class="py-2 w-[28%]">Features</th>
</tr>
</thead>
<tbody>
<tr class="border-b border-gray-100 align-top">
<td class="py-3 pr-4 w-[40%]"><code class="text-indigo-700">qwen3.8-27b</code><div class="text-xs text-gray-500 mt-1">Dedicated single-tenant GPU — RTX 3090 24 GB (standard) or RTX 5090 32 GB (premium) — IQ4_XS GGUF, MTP speculative decoding. Internal exploration team (beta).</div></td>
<td class="py-3 pr-4 text-right whitespace-nowrap">131K</td>
<td class="py-3 pr-4 text-right" colspan="2"><a href="#selfhosted" class="inline-block px-2 py-0.5 rounded-full text-xs font-semibold text-indigo-700 bg-indigo-50 border border-indigo-200 hover:bg-indigo-100 transition-colors">contact</a></td>
<td class="py-3"></td>
</tr>
</tbody>
</table>
</div>
<p class="text-xs text-gray-500">
Models tagged <span class="inline-block px-1.5 py-0.5 rounded bg-gray-100 border border-gray-200 text-gray-600">prompt cache</span> bill cached input tokens at a deep discount.
Self-hosted routes are for the internal exploration team during beta.
<strong>Prices are USD per 1M tokens</strong> and refresh automatically from DeepInfra.
⚠️ The self-hosted GPU is dedicated, but under load Qwen3.8 requests overflow to <strong>rented third-party <a class="text-indigo-600 underline decoration-indigo-200 underline-offset-2" href="https://vast.ai" rel="noopener">VAST.ai</a> capacity</strong>.
Catalog generated 2026-10-13T05:59:01Z.</p>
<!-- MODEL-CATALOG:END -->

## Self-hosted GPU (beta) {#selfhosted}

<div class="not-prose my-2">
<p class="max-w-2xl text-gray-500">
A dedicated GPU running <code>qwen3.8-27b</code> for you alone — on-demand, hourly cost-plus,
automatic shutdown when idle. Limited beta slots.
</p>
<form action="https://formspree.io/f/mwvwjlyy" method="POST" class="mt-4 max-w-xl bg-white border border-gray-200 rounded-2xl p-6 shadow-sm text-left">
<input type="hidden" name="_subject" value="Self-hosted (beta) quote request">
<div class="grid grid-cols-1 sm:grid-cols-2 gap-3 mb-3">
<div><label class="block text-sm font-medium text-gray-700 mb-1">Name</label>
<input name="name" type="text" autocomplete="name" required class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm"></div>
<div><label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
<input name="email" type="email" autocomplete="email" required class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm"></div>
</div>
<div class="mb-3"><label class="block text-sm font-medium text-gray-700 mb-1">Company <span class="text-gray-400 font-normal">(optional)</span></label>
<input name="company" type="text" autocomplete="organization" class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm"></div>
<div class="mb-4"><label class="block text-sm font-medium text-gray-700 mb-1">What do you need?</label>
<textarea name="message" rows="4" required placeholder="Model, typical context size, expected volume, preferred schedule…" class="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm"></textarea></div>
<button type="submit" class="w-full bg-indigo-600 text-white py-2.5 px-4 rounded-lg text-sm font-semibold hover:bg-indigo-500 transition-colors">Request a quote</button>
</form>
<p class="max-w-xl mt-3 text-xs text-gray-500">You'll get a per-hour quote by email (2× hardware cost, standard or premium tier). The GPU starts on demand and shuts down automatically after 30 minutes idle.</p>
</div>





## How token billing works {#billing}

1. **Buy a credit pack** (Stripe) — e.g. `$5 → 500k tokens` at the pack's
   fixed rate. Packs never expire while the account is in good standing.
2. **Spend is metered per token** on your virtual key — input + output, at
   the published rate, with caching discounts applied automatically.
3. **You see everything** in the dashboard: spend per model, per key, per day.
   Hard spend caps are enforced, not advisory.

> **Beta:** while we're in beta, new accounts get free credits — no card
> required. Stripe top-ups go live with the public launch.
## Terms & privacy

<div class="not-prose my-2">
<p id="tp-text" class="text-sm leading-relaxed text-gray-500">
By using the service you agree to our <a href="/privacy/" class="text-indigo-600 underline">Privacy Policy</a>.
Terms of Service (B2B and B2C), the Art. 28 Data Processing Agreement, the sub-processor list and the
Acceptable Use Policy are being finalised with counsel and will be published here before B2B launch —
until then the service is offered on a best-efforts beta basis. Data handling in one line: no prompt
or output bodies are logged at our layer — metadata only (model, token counts, timestamps, key ID).
Upstream inference (DeepInfra) is zero-data-retention by contract; the rented-GPU tier is not for
sensitive data (see above).
</p>
<button id="tp-toggle" class="mt-3 px-3 py-1.5 rounded-lg text-xs font-medium text-gray-600 bg-white border border-gray-200 hover:bg-gray-50 transition-colors">Aa — larger text</button>
</div>

<script>
(function(){
var t=document.getElementById("tp-text"),b=document.getElementById("tp-toggle");
if(!t||!b)return;
b.onclick=function(){
var big=t.classList.toggle("text-sm");
t.classList.toggle("text-base",!big);
t.classList.toggle("text-gray-500",big);
t.classList.toggle("text-gray-800",!big);
b.textContent=big?"Aa — larger text":"Aa — smaller text";
};
})();
</script>
