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
