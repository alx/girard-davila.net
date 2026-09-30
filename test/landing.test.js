// Validation suite for the /llm/ landing page, run against the
// production build (hugo --minify output in ../public) served by serve.js.
// These are the same checks done live during the org-7y4 polish pass and
// the Formspree join-form wiring. Formspree is stubbed: no real
// submissions leave the test run.
const { test, expect } = require('@playwright/test');

const WIDTHS = [1440, 768, 375];
const URL = '/llm/';

test.describe('LLM landing page', () => {
  test('no horizontal scroll, exactly one h1, at every width', async ({ page }) => {
    for (const w of WIDTHS) {
      await page.setViewportSize({ width: w, height: 900 });
      await page.goto(URL, { waitUntil: 'load' });
      // Tailwind Play CDN generates CSS after load; wait for it.
      await page
        .waitForFunction(
          () =>
            document.querySelectorAll('.prose h2, .prose thead').length > 0 &&
            getComputedStyle(document.querySelector('.prose h2')).fontSize !== 'medium',
          null,
          { timeout: 15000 }
        )
        .catch(() => {}); // CSS-gen wait is advisory; assertions below are the real checks
      const overflow = await page.evaluate(
        () => document.documentElement.scrollWidth > window.innerWidth
      );
      expect(overflow, `horizontal scroll at ${w}px`).toBe(false);
      const h1s = await page.locator('h1').count();
      expect(h1s, `h1 count at ${w}px (want 1)`).toBe(1);
    }
  });

  test('tailwind typography is active (h2 sized, thead ruled)', async ({
    page
  }) => {
    await page.setViewportSize({ width: 1440, height: 900 });
    await page.goto(URL, { waitUntil: 'load' });
    await page.waitForFunction(
      () =>
        parseFloat(getComputedStyle(document.querySelector('.prose h2')).fontSize) > 16,
      null,
      { timeout: 15000 }
    );
    const h2size = await page.evaluate(() =>
      parseFloat(getComputedStyle(document.querySelector('.prose h2')).fontSize)
    );
    expect(h2size).toBeGreaterThan(16);
    await page.waitForFunction(
      () => {
        const t = document.querySelector('thead');
        return t && parseFloat(getComputedStyle(t).borderBottomWidth) >= 1;
      },
      null,
      { timeout: 15000 }
    );
  });

  test('hero clears the navbar (no -mt overlap)', async ({ page }) => {
    await page.setViewportSize({ width: 1440, height: 900 });
    await page.goto(URL, { waitUntil: 'load' });
    await page.waitForFunction(
      () => {
        const nav = document.querySelector('header, nav');
        const hero = document.querySelector('.not-prose');
        if (!nav || !hero) return false;
        return hero.getBoundingClientRect().top > nav.getBoundingClientRect().bottom;
      },
      null,
      { timeout: 15000 }
    );
  });

  test('join form gates the steps; submit unlocks, persists, resets', async ({
    page
  }) => {
    // Stub Formspree: never let a test submission reach the network.
    await page.route('**/formspree.io/**', (route) =>
      route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify({ next: '/thanks', ok: true })
      })
    );
    await page.setViewportSize({ width: 1440, height: 900 });
    await page.goto(URL, { waitUntil: 'load' });

    // Gated initial state.
    await expect(page.locator('#join-form')).toBeVisible();
    await expect(page.locator('#join-steps')).toBeHidden();
    await expect(page.locator('#join-chip')).toBeHidden();

    // Submit the form.
    await page.fill('#jf-name', 'CI Test');
    await page.fill('#jf-email', 'ci+test@example.invalid');
    await page.fill('#jf-msg', 'playwright validation run');
    await page.click('#join-form button[type=submit]');

    // Unlocked.
    await expect(page.locator('#join-status')).toHaveText(/You are in/);
    await expect(page.locator('#join-steps')).toBeVisible();
    await expect(page.locator('#join-chip')).toBeVisible();
    await expect(page.locator('#join-form')).toBeHidden();

    // Persisted across a reload.
    await page.reload({ waitUntil: 'load' });
    await expect(page.locator('#join-steps')).toBeVisible();
    await expect(page.locator('#join-chip')).toBeVisible();
    await expect(page.locator('#join-form')).toBeHidden();

    // Reset link re-locks for re-testing.
    await page.click('#join-reset');
    await expect(page.locator('#join-form')).toBeVisible();
    await expect(page.locator('#join-steps')).toBeHidden();
  });

  test('no horizontal scroll at mobile width after unlock', async ({ page }) => {
    await page.route('**/formspree.io/**', (route) =>
      route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify({ next: '/thanks', ok: true })
      })
    );
    await page.setViewportSize({ width: 375, height: 812 });
    await page.goto(URL, { waitUntil: 'load' });
    await page.fill('#jf-name', 'CI Mobile');
    await page.fill('#jf-email', 'ci+mobile@example.invalid');
    await page.click('#join-form button[type=submit]');
    await expect(page.locator('#join-steps')).toBeVisible();
    const overflow = await page.evaluate(
      () => document.documentElement.scrollWidth > window.innerWidth
    );
    expect(overflow, 'horizontal scroll at 375px after unlock').toBe(false);
  });
});
