#!/bin/bash
set -e

echo "=== GhostTrack-v2 · MASTER FUSION RITUAL ==="

# ---------------------------------------------------------
# 1) CARTELLE
# ---------------------------------------------------------
mkdir -p webapp/static/panels/quantum
mkdir -p webapp/static
mkdir -p quantum

# ---------------------------------------------------------
# 2) PANNELLI QUANTICI
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

# ---------------------------------------------------------
# 3) BLOCCO DASHBOARD QUANTICA
# ---------------------------------------------------------
cat > webapp/static/quantum_dashboard_block.html << 'QB'
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
QB

# ---------------------------------------------------------
# 4) SCRIPT DI SYNC QUANTICO
# ---------------------------------------------------------
cat > ghosttrack_quantum_sync.sh << 'QS'
#!/bin/bash
set -e

echo "=== GhostTrack-v2 · Quantum Dashboard Sync ==="

OUT="webapp/static/quantum_snapshot.json"

python quantum/quantum_engine.py > "$OUT"

echo "Snapshot quantico aggiornato: $OUT"
QS

chmod +x ghosttrack_quantum_sync.sh

# ---------------------------------------------------------
# 5) INSERIMENTO AUTOMATICO IN DASHBOARD.HTML
# ---------------------------------------------------------
if [ -f "dashboard.html" ]; then
  if ! grep -q "quantum_dashboard_block" dashboard.html; then
    echo "Inserimento blocco quantico in dashboard.html"
    echo '<!--#include file="static/quantum_dashboard_block.html" -->' >> dashboard.html
  else
    echo "Blocco quantico già presente in dashboard.html"
  fi
else
  echo "ATTENZIONE: dashboard.html non trovato."
  echo "Inserisci manualmente:"
  echo '  <!--#include file="static/quantum_dashboard_block.html" -->'
fi

# ---------------------------------------------------------
# 6) AGGIUNTA AL MASTER RITUAL
# ---------------------------------------------------------
if [ -f "ghosttrack_master.sh" ]; then
  if ! grep -q "ghosttrack_quantum_sync.sh" ghosttrack_master.sh 2>/dev/null; then
    echo "Aggancio Quantum Sync al Master Ritual"
    echo 'bash ghosttrack_quantum_sync.sh' >> ghosttrack_master.sh
  else
    echo "Quantum Sync già presente nel Master Ritual"
  fi
else
  echo "ATTENZIONE: ghosttrack_master.sh non trovato."
  echo "Puoi aggiungere manualmente:"
  echo '  bash ghosttrack_quantum_sync.sh'
fi

# ---------------------------------------------------------
# 7) AGGIUNTA ALIAS
# ---------------------------------------------------------
SHELL_RC="$HOME/.bashrc"
if [ -n "$ZSH_VERSION" ]; then
  SHELL_RC="$HOME/.zshrc"
fi

if [ -f "$SHELL_RC" ]; then
  if ! grep -q "alias gt_quantum" "$SHELL_RC" 2>/dev/null; then
    echo "alias gt_quantum='bash \"$PWD/ghosttrack_quantum_sync.sh\"'" >> "$SHELL_RC"
    echo "Alias gt_quantum aggiunto in $SHELL_RC"
  else
    echo "Alias gt_quantum già presente in $SHELL_RC"
  fi
else
  echo "ATTENZIONE: file $SHELL_RC non trovato."
  echo "Aggiungi manualmente:"
  echo "  alias gt_quantum='bash \"$PWD/ghosttrack_quantum_sync.sh\"'"
fi

echo
echo "=== MASTER FUSION COMPLETATO ==="
echo "Quantum Dashboard generata e integrata."
echo "Quantum Sync aggiunto al Master Ritual."
echo "Alias gt_quantum configurato."
