/* Read version and download URL from the Windows updater manifest. */
(() => {
  'use strict';
  const fallback = 'https://github.com/autotdk/ilsq/releases/latest/download/iLSQ.exe';
  function applyRelease(xml) {
    const doc = new DOMParser().parseFromString(xml, 'application/xml');
    if (doc.querySelector('parsererror') || doc.documentElement.tagName !== 'item') throw new Error('Invalid manifest');
    const values = tag => Array.from(doc.documentElement.children).filter(el => el.tagName === tag);
    const versions = values('version'), urls = values('url');
    if (versions.length !== 1 || urls.length !== 1) throw new Error('Duplicate or missing fields');
    const version = versions[0].textContent.trim();
    if (!/^\d{1,5}(\.\d{1,5}){0,3}$/.test(version) || version.split('.').some(n => Number(n) > 65535)) throw new Error('Invalid version');
    const url = new URL(urls[0].textContent.trim());
    if (url.protocol !== 'https:' || url.username || url.password) throw new Error('Invalid download URL');
    document.querySelectorAll('.download-link').forEach(a => { a.href = url.href; });
    document.getElementById('release-status').textContent = 'Phiên bản ' + version + ' · Windows 10 / 11 · 64-bit';
  }
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), 8000);
  fetch('update.xml?t=' + Date.now(), { signal: controller.signal, cache: 'no-store' })
    .then(response => { if (!response.ok) throw new Error('Manifest unavailable'); return response.text(); })
    .then(applyRelease)
    .catch(() => { document.querySelectorAll('.download-link').forEach(a => { a.href = fallback; }); })
    .finally(() => clearTimeout(timer));
})();
