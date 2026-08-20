/* Simple cache-first service worker. Only used when the app is served over
   http(s) — when opened directly from the file system the app runs without it. */
const CACHE = 'tireplus-invoices-v1';
const ASSETS = ['./', './index.html', './assets/logo.png', './data/invoices.js', './data/items.js', './manifest.json'];
self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(ASSETS)).then(() => self.skipWaiting()));
});
self.addEventListener('activate', e => {
  e.waitUntil(caches.keys().then(keys => Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)))).then(() => self.clients.claim()));
});
self.addEventListener('fetch', e => {
  e.respondWith(caches.match(e.request).then(hit => hit || fetch(e.request)));
});
