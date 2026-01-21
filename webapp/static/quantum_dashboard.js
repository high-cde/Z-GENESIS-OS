async function loadQuantumSnapshot() {
  try {
    const res = await fetch('/static/quantum_snapshot.json?_=' + Date.now());
    const data = await res.json();

    const qlinkEl = document.getElementById('qlink-output');
    const sqiaEl = document.getElementById('sqia-output');
    const mrseEl = document.getElementById('mrse-output');
    const healthEl = document.getElementById('quantum-health-output');

    if (qlinkEl) qlinkEl.textContent = JSON.stringify(data.qlink, null, 2);
    if (sqiaEl) sqiaEl.textContent = JSON.stringify(data.identity, null, 2);
    if (mrseEl) mrseEl.textContent = JSON.stringify(data.realities, null, 2);

    if (healthEl) {
      const health = {
        modules_active: data?.qlink?.modules_active || 0,
        realities_synced: data?.realities?.realities_synced || false,
        identity_hash: data?.identity?.hash || null,
        last_update: new Date(data?.timestamp * 1000).toISOString()
      };
      healthEl.textContent = JSON.stringify(health, null, 2);
    }

  } catch (e) {
    console.error("Quantum snapshot error:", e);
  }
}

async function amplifySignal() {
  const input = document.getElementById('qra-input');
  const out = document.getElementById('qra-output');
  const signal = input.value || "default-signal";

  const encoded = new TextEncoder().encode(signal);
  const buf = await crypto.subtle.digest("SHA-256", encoded);
  const hashArray = Array.from(new Uint8Array(buf));
  const hashHex = hashArray.map(b => b.toString(16).padStart(2, "0")).join("");

  out.textContent = JSON.stringify({
    input: signal,
    amplified: hashHex,
    resonance_level: signal.length * 42
  }, null, 2);
}

setInterval(loadQuantumSnapshot, 5000);
window.addEventListener("load", loadQuantumSnapshot);
