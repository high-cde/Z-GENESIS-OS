#!/bin/bash
set -e

echo "=== GhostTrack-v2 · Quantum Dashboard Setup ==="

# 1) Cartella pannelli
mkdir -p webapp/static/panels/quantum

# 2) Pannello Q-Link
cat > webapp/static/panels/quantum/quantum_qlink.html << 'P1'
<div class="quantum-panel">
  <h2>Q‑Link Protocol</h2>
  <pre id="qlink-output">Loading...</pre>
</div>
P1

# 3) Pannello SQIA
cat > webapp/static/panels/quantum/quantum_identity.html << 'P2'
<div class="quantum-panel">
  <h2>Sub‑Quantum Identity Anchor</h2>
  <pre id="sqia-output">Loading...</pre>
</div>
P2

# 4) Pannello QRA
cat > webapp/static/panels/quantum/quantum_resonance.html << 'P3'
<div class="quantum-panel">
  <h2>Quantum Resonance Amplifier</h2>
  <input id="qra-input" placeholder="Inserisci un segnale logico">
  <button onclick="amplifySignal()">Amplifica</button>
  <pre id="qra-output">Waiting...</pre>
</div>
P3

# 5) Pannello MRSE
cat > webapp/static/panels/quantum/quantum_realities.html << 'P4'
<div class="quantum-panel">
  <h2>Multi‑Reality Sync Engine</h2>
  <pre id="mrse-output">Loading...</pre>
</div>
P4

# 6) Blocco Quantum Dashboard
cat > webapp/static/quantum_dashboard_block.html << 'PBLOCK'
<!-- QUANTUM DASHBOARD BLOCK -->
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
</div>
PBLOCK

# 7) Script di sync Quantum
cat > ghosttrack_quantum_sync.sh << 'QS'
#!/bin/bash
set -e

echo "=== GhostTrack-v2 · Quantum Dashboard Sync ==="

OUT="webapp/static/quantum_snapshot.json"

python quantum/quantum_engine.py > "$OUT"

echo "Snapshot quantico aggiornato: $OUT"
QS

chmod +x ghosttrack_quantum_sync.sh

echo
echo "Quantum Dashboard generata."
echo "Ora inserisci in dashboard.html la riga:"
echo '  <!--#include file="static/quantum_dashboard_block.html" -->'
echo
echo "Per aggiornare lo snapshot quantico:"
echo "  bash ghosttrack_quantum_sync.sh"
