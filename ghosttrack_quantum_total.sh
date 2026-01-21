#!/bin/bash
set -e

echo "=== GHOSTTRACK · QUANTUM TOTAL RITUAL ==="

# ---------------------------------------------------------
# CARTELLE
# ---------------------------------------------------------
mkdir -p webapp/static/panels/quantum
mkdir -p webapp/static
mkdir -p quantum

# ---------------------------------------------------------
# PANNELLI QUANTICI
# ---------------------------------------------------------

# Q-LINK
cat > webapp/static/panels/quantum/quantum_qlink.html << 'Q1'
<div class="quantum-panel">
  <h2>Q‑Link Protocol</h2>
  <pre id="qlink-output">Loading...</pre>
</div>
Q1

# SQIA
cat > webapp/static/panels/quantum/quantum_identity.html << 'Q2'
<div class="quantum-panel">
  <h2>Sub‑Quantum Identity Anchor</h2>
  <pre id="sqia-output">Loading...</pre>
</div>
Q2

# QRA
cat > webapp/static/panels/quantum/quantum_resonance.html << 'Q3'
<div class="quantum-panel">
  <h2>Quantum Resonance Amplifier</h2>
  <input id="qra-input" placeholder="Inserisci un segnale logico">
  <button onclick="amplifySignal()">Amplifica</button>
  <pre id="qra-output">Waiting...</pre>
</div>
Q3

# MRSE
cat > webapp/static/panels/quantum/quantum_realities.html << 'Q4'
<div class="quantum-panel">
  <h2>Multi‑Reality Sync Engine</h2>
  <pre id="mrse-output">Loading...</pre>
</div>
Q4

# QUANTUM HEALTH
cat > webapp/static/panels/quantum/quantum_health.html << 'Q5'
<div class="quantum-panel">
  <h2>Quantum Health</h2>
  <pre id="quantum-health-output">Loading...</pre>
</div>
Q5

# ---------------------------------------------------------
# BLOCCO DASHBOARD QUANTICA
# ---------------------------------------------------------
cat > webapp/static/quantum_dashboard_block.html << 'QB'
<div class="quantum-dashboard">
  <h1>Quantum Layer</h1>

  <section id="quantum-qlink">
    <!--#include file="static/panels/quantum/quantum_qlink.html" -->
  </section>

  <section id="quantum-identity">
    <!--#include file="static/panels/quantum/quantum_identity.html" -->
  </section>

  <section id="quantum-resonance">
    <!--#include file="static/panels/quantum/quantum_resonance.html" -->
  </section>

  <section id="quantum-realities">
    <!--#include file="static/panels/quantum/quantum_realities.html" -->
  </section>

  <section id="quantum-health">
    <!--#include file="static/panels/quantum/quantum_health.html" -->
  </section>
</div>
QB

# ---------------------------------------------------------
# JAVASCRIPT: REFRESH + QRA
# ---------------------------------------------------------
cat > webapp/static/quantum_dashboard.js << 'JS'
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
JS

# ---------------------------------------------------------
# SCRIPT DI SYNC QUANTICO
# ---------------------------------------------------------
cat > ghosttrack_quantum_sync.sh << 'QS'
#!/bin/bash
set -e
python quantum/quantum_engine.py > webapp/static/quantum_snapshot.json
echo "Quantum snapshot aggiornato."
QS

chmod +x ghosttrack_quantum_sync.sh

# ---------------------------------------------------------
# INSERIMENTO AUTOMATICO IN DASHBOARD.HTML
# ---------------------------------------------------------
if [ -f "dashboard.html" ]; then
  if ! grep -q "quantum_dashboard_block" dashboard.html; then
    echo '<!--#include file="static/quantum_dashboard_block.html" -->' >> dashboard.html
  fi
fi

# ---------------------------------------------------------
# AGGIUNTA AL MASTER RITUAL
# ---------------------------------------------------------
if [ -f "ghosttrack_master.sh" ]; then
  if ! grep -q "ghosttrack_quantum_sync.sh" ghosttrack_master.sh; then
    echo 'bash ghosttrack_quantum_sync.sh' >> ghosttrack_master.sh
  fi
fi

# ---------------------------------------------------------
# ALIAS
# ---------------------------------------------------------
if ! grep -q "gt_quantum" ~/.bashrc 2>/dev/null; then
  echo "alias gt_quantum='bash \"$PWD/ghosttrack_quantum_sync.sh\"'" >> ~/.bashrc
fi

echo "=== QUANTUM TOTAL RITUAL COMPLETATO ==="
