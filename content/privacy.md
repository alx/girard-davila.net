---
title: "Privacy Policy"
description: "Privacy policy for api.girard-davila.net and the Girard-Davila open-source / LLM services."
---

# Privacy Policy

_Effective: 2026-10-11 · This describes how the **api.girard-davila.net** LLM
service (a LiteLLM proxy fronting self-hosted and deepinfra models) and the
Girard-Davila open-source project pages handle personal data. It is a draft
policy provided in good faith; review it and adapt it to your legal
requirements (including the GDPR - RGPD) before relying on it as a formal
legal document._

## What we collect
- **Account / sign-in identity.** When you sign in to
  api.girard-davila.net with SSO (GitHub, Google, or Microsoft), we receive
  your provider identity (login/name/email) to create your user account and
  issue an API key. Your key is stored only on your machine (e.g. in
  `~/.pi/agent/auth.json`) unless you choose to paste it.
- **Usage & spend data.** Requests you make through the proxy are logged
  (model, token counts, timestamps, spend) in order to meter usage, enforce
  budgets, and bill/attribute cost.
- **Contact.** If you email us (e.g. the contact address on this site), we
  keep that correspondence.

## How we use it
- To operate the service (authenticate, meter, rate-limit, bill).
- To support you and improve reliability.
- We do **not** sell your personal data, and we do not use your prompts for
  targeted advertising.

## What we share / third parties
- **Deepinfra** (third-party): when you use the hosted `deepseek-v4.1-flash`
  model, prompts are forwarded to DeepInfra Inc. under their terms/privacy
  policy. Self-hosted models run on our own hardware and your prompts do not
  leave our infrastructure for those.
- **Cloudflare** (edge/CDN + tunnel): standard request routing/caching.
- We disclose data only where legally required.

## Retention
Usage/spend logs are retained as long as reasonably needed for billing,
abuse prevention, and service operation, and are deleted when they no longer
serve those purposes. Prompt content is not retained beyond the request for
the self-hosted models.

## Your rights (GDPR)
You may request access to, correction of, or deletion of your account and
associated data, and object to or restrict processing, by contacting us (see
below). We respond within the timeframes required by law.

## Cookies
The site and SSO flow use only the strictly necessary cookies/session tokens
required for sign-in and security. No advertising or cross-site tracking
cookies are used.

## Contact
**Girard-Davila** · <girard.davila@gmail.com> - for any privacy question or
request.
