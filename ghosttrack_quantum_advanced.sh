#!/bin/bash
set -e

echo "=== GHOSTTRACK · QUANTUM ADVANCED RITUAL ==="

mkdir -p webapp/static/panels/quantum
mkdir -p webapp/static

# 1) PANNELLO GRAFICI QUANTICI
cat > webapp/static/panels/quantum/quantum_charts.html << 'PCH'
<div class="quantum-panel">
  <h2>Quantum Metrics</h2>
  <canvas id="quantum-chart" width="400" height="200" style="background:#050510;border:1px solid #444;"></canvas>
  <pre id="quantum-chart-meta">Waiting...</pre>
</div>
PCH

# 2) PANNELLO STREAMING
cat > webapp/static/panels/quantum/quantum_stream.html << 'PST'
<div class="quantum-panel">
  <h2>Quantum Stream</h2>
  <pre id="quantum-stream-output">Streaming...</pre>
</div>
PST

# 3) PANNELLO LOG
cat > webapp/static/panels/quantum/quantum_logs.html << 'PLG'
<div class="quantum-panel">
  <h2>Quantum Log</h2>
  <pre id="quantum-log-output">Loading logs...</pre>
</div>
PLG

# 4) ESTENSIONE BLOCCO DASHBOARD QUANTICA
if [ -f webapp/static/quantum_dashboard_block.html ]; then
  if ! grep -q "quantum-charts" webapp/static/quantum_dashboard_block.html; then
    cat >> webapp/static/quantum_dashboard_block.html << 'QB'
  <section id="quantum-charts">
    <!--#include file="static/panels/quantum/quantum_charts.html" -->
  </section>

  <section id="quantum-stream">
    <!--#include file="static/panels/quantum/quantum_stream.html" -->
  </section>

  <section id="quantum-logs">
    <!--#include file="static/panels/quantum/quantum_logs.html" -->
  </section>
QB
  fi
fi

# 5) JAVASCRIPT AVANZATO: GRAFICI + STREAMING + LOG
cat > webapp/static/quantum_advanced.js << 'JS'
const quantumHistory = [];

async function fetchSnapshot() {
  try {
    const res = await fetch('/static/quantum_snapshot.json?_=' + Date.now());
    if (!res.ok) return;
    const data = await res.json();
    quantumHistory.push({
      t: Date.now(),
      modules_active: data?.qlink?.modules_active || 0
    });
    if (quantumHistory.length > 100) quantumHistory.shift();
    updateChart();
    updateStream(data);
    updateLog();
  } catch (e) {
    console.error('Quantum fetch error:', e);
  }
}

function updateChart() {
  const canvas = document.getElementById('quantum-chart');
  const meta = document.getElementById('quantum-chart-meta');
  if (!canvas || !canvas.getContext) return;
  const ctx = canvas.getContext('2d');
  ctx.clearRect(0, 0, canvas.width, canvas.height);

  const maxVal = Math.max(1, ...quantumHistory.map(p => p.modules_active));
  const minVal = 0;
  const len = quantumHistory.length;

  ctx.strokeStyle = '#444';
  ctx.beginPath();
  ctx.moveTo(0, canvas.height - 20);
  ctx.lineTo(canvas.width, canvas.height - 20);
  ctx.stroke();

  ctx.strokeStyle = '#00ffcc';
  ctx.beginPath();
  quantumHistory.forEach((p, i) => {
    const x = (i / Math.max(1, len - 1)) * (canvas.width - 20) + 10;
    const yNorm = (p.modules_active - minVal) / (maxVal - minVal || 1);
    const y = canvas.height - 20 - yNorm * (canvas.height - 40);
    if (i === 0) ctx.moveTo(x, y);
    else ctx.lineTo(x, y);
  });
  ctx.stroke();

  if (meta) {
    const last = quantumHistory[quantumHistory.length - 1] || {};
    meta.textContent = JSON.stringify({
      last_modules_active: last.modules_active || 0,
      samples: quantumHistory.length,
      max_modules_active: maxVal
    }, null, 2);
  }
}

function updateStream(data) {
  const el = document.getElementById('quantum-stream-output');
  if (!el) return;
  el.textContent = JSON.stringify({
    identity: data.identity,
    qlink: data.qlink,
    realities: data.realities
  }, null, 2);
}

async function updateLog() {
  const el = document.getElementById('quantum-log-output');
  if (!el) return;
  try {
    const res = await fetch('/static/quantum_log.jsonl?_=' + Date.now());
    if (!res.ok) {
      el.textContent = 'Nessun log ancora.';
      return;
    }
    const text = await res.text();
    const lines = text.trim().split('\n').slice(-20);
    el.textContent = lines.join('\n');
  } catch (e) {
    el.textContent = 'Errore lettura log: ' + e;
  }
}

setInterval(fetchSnapshot, 4000);
window.addEventListener('load', fetchSnapshot);
JS

# 6) LOGGING QUANTICO: RISCRIVE ghosttrack_quantum_sync.sh
cat > ghosttrack_quantum_sync.sh << 'QS'
#!/bin/bash
set -e
SNAP="webapp/static/quantum_snapshot.json"
LOG="webapp/static/quantum_log.jsonl"
python quantum/quantum_engine.py > "$SNAP"
ts=$(date -Iseconds)
echo "{\"timestamp\":\"$ts\", \"snapshot\": $(cat "$SNAP")}" >> "$LOG"
echo "Quantum snapshot aggiornato e loggato."
QS

chmod +x ghosttrack_quantum_sync.sh

# 7) INCLUDE JS NELLA DASHBOARD
if [ -f "dashboard.html" ]; then
  if ! grep -q "quantum_advanced.js" dashboard.html; then
    echo '<script src="/static/quantum_advanced.js"></script>' >> dashboard.html
  fi
fi

echo "=== QUANTUM ADVANCED RITUAL COMPLETATO ==="
