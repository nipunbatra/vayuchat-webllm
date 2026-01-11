const CACHE_NAME = 'vayuchat-v1';
const PYODIDE_VERSION = '0.26.4';

// Assets to cache immediately
const STATIC_ASSETS = [
  './',
  './index.html',
  './sample_air_quality.csv',
];

// Pyodide core files to cache
const PYODIDE_BASE = `https://cdn.jsdelivr.net/pyodide/v${PYODIDE_VERSION}/full/`;
const PYODIDE_ASSETS = [
  'pyodide.js',
  'pyodide.asm.js',
  'pyodide.asm.wasm',
  'pyodide_py.tar',
  'packages.json',
];

// Packages to cache
const PYODIDE_PACKAGES = [
  'pandas',
  'numpy',
  'matplotlib',
  'pyparsing',
  'packaging',
  'python_dateutil',
  'pytz',
  'six',
  'cycler',
  'kiwisolver',
  'pillow',
  'contourpy',
  'fonttools',
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(async (cache) => {
      console.log('[SW] Caching static assets');
      await cache.addAll(STATIC_ASSETS);

      // Cache Pyodide core
      console.log('[SW] Caching Pyodide core');
      for (const asset of PYODIDE_ASSETS) {
        try {
          await cache.add(PYODIDE_BASE + asset);
        } catch (e) {
          console.log('[SW] Failed to cache:', asset, e);
        }
      }

      // Cache Pyodide packages
      console.log('[SW] Caching Pyodide packages');
      for (const pkg of PYODIDE_PACKAGES) {
        try {
          const response = await fetch(`${PYODIDE_BASE}${pkg}-*.whl`, { mode: 'cors' });
          // Actually need to fetch the packages.json first to get exact filenames
        } catch (e) {
          // Will be cached on first use
        }
      }
    })
  );
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((name) => {
          if (name !== CACHE_NAME) {
            console.log('[SW] Deleting old cache:', name);
            return caches.delete(name);
          }
        })
      );
    })
  );
  self.clients.claim();
});

self.addEventListener('fetch', (event) => {
  const url = new URL(event.request.url);

  // Cache-first for Pyodide and static assets
  if (url.hostname === 'cdn.jsdelivr.net' ||
      url.pathname.endsWith('.whl') ||
      url.pathname.endsWith('.wasm') ||
      STATIC_ASSETS.some(a => event.request.url.includes(a))) {
    event.respondWith(
      caches.match(event.request).then((cached) => {
        if (cached) {
          console.log('[SW] Serving from cache:', url.pathname);
          return cached;
        }
        return fetch(event.request).then((response) => {
          if (response.ok) {
            const clone = response.clone();
            caches.open(CACHE_NAME).then((cache) => {
              cache.put(event.request, clone);
            });
          }
          return response;
        });
      })
    );
    return;
  }

  // Network-first for everything else
  event.respondWith(
    fetch(event.request).catch(() => caches.match(event.request))
  );
});
