// Service Worker: macht AGAdemie offline nutzbar.
// Seite: zuerst aus dem Netz (damit Updates sofort ankommen), sonst aus dem Cache.
// Icons und Schriften: aus dem Cache, im Hintergrund aktualisiert.
const CACHE='agademie-v1';
const CORE=['./','icons/site.webmanifest','icons/favicon.svg','icons/favicon.ico','icons/apple-touch-icon.png','icons/icon-192.png','icons/icon-512.png',
  'fonts/barlow-condensed-500.woff2','fonts/barlow-condensed-600.woff2','fonts/barlow-condensed-700.woff2','fonts/source-sans-3.woff2'];

self.addEventListener('install',e=>{
  e.waitUntil(caches.open(CACHE).then(c=>c.addAll(CORE)).then(()=>self.skipWaiting()));
});
self.addEventListener('activate',e=>{
  e.waitUntil(caches.keys().then(ks=>Promise.all(ks.filter(k=>k!==CACHE).map(k=>caches.delete(k)))).then(()=>self.clients.claim()));
});
self.addEventListener('fetch',e=>{
  const r=e.request;if(r.method!=='GET') return;
  const u=new URL(r.url);
  if(r.mode==='navigate'){ // Seite: zuerst aus dem Netz
    const key='./';
    e.respondWith(fetch(r).then(res=>{if(res.ok){const c=res.clone();caches.open(CACHE).then(x=>x.put(key,c))}return res})
      .catch(()=>caches.match(key)));
    return;
  }
  if(u.origin!==location.origin) return;
  e.respondWith(caches.open(CACHE).then(c=>c.match(r).then(hit=>{
    const net=fetch(r).then(res=>{if(res.ok||res.type==='opaque') c.put(r,res.clone());return res});
    if(hit){e.waitUntil(net.catch(()=>{}));return hit}
    return net;
  })));
});
