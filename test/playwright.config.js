const { defineConfig } = require('@playwright/test');

module.exports = defineConfig({
  testDir: '.',
  testMatch: /landing\.test\.js$/,
  timeout: 45000,
  expect: { timeout: 10000 },
  use: {
    baseURL: 'http://127.0.0.1:4173'
  },
  webServer: {
    command: 'node serve.js',
    url: 'http://127.0.0.1:4173/llm/',
    timeout: 15000,
    reuseExistingServer: true
  }
});
