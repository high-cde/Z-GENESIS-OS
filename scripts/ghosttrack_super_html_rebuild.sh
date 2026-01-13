#!/usr/bin/env bash
set -euo pipefail
cd ~/GhostTrack-v2

echo "🧼 [1] Pulizia processi e cache"
bash scripts/ghosttrack_termux_stop_full.sh || true
rm -f tmp/*.pid tmp/*.log __pycache__/* || true
find . -name '*.pyc' -delete

echo "🧱 [2] Ricostruzione pannello Crediti Energetici"
mkdir -p webapp/static/panels docs

cat > webapp/static/panels/crediti_energetici.html <<'HTML'
<!doctype html>
<html lang="it">
<head>
  <meta charset="utf-8" />
  <title>Crediti Energetici — GhostTrack</title>
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <link rel="stylesheet" href="/static/gt_dark.css">
</head>
<body>
  <div class="container">
    <header>
      <h1>⚡ Crediti Energetici</h1>
      <p class="subtitle">Bilancio, flussi, impatti e riconoscimenti energetici nella costellazione GhostTrack‑v2</p>
    </header>

    <section class="card">
      <h2>🌍 Origine e flusso</h2>
      <p>Ogni modulo della costellazione contribuisce a un ecosistema energetico distribuito. I crediti energetici rappresentano l’impatto positivo, la resilienza e l’efficienza di ogni nodo.</p>
    </section>

    <section class="card">
      <h2>🔋 Bilancio attuale</h2>
      <ul id="energy-stats">
        <li>CyberDefense: +12.4 kWh</li>
        <li>Orbital & Space: +8.7 kWh</li>
        <li>Agro & Ambiente: +15.2 kWh</li>
        <li>Reti & Mesh: +10.1 kWh</li>
        <li>Resilienza & Emergenza: +9.5 kWh</li>
        <li>dr. HighKali (AGI): +6.6 kWh</li>
      </ul>
    </section>

    <section class="card">
      <h2>🎖️ Riconoscimenti</h2>
      <p>Crediti assegnati a moduli che hanno superato soglie di efficienza, sicurezza e impatto ambientale positivo.</p>
      <ul>
        <li>🟢 Agro & Ambiente — “Eco Impatto 2026”</li>
        <li>🟣 Reti & Mesh — “Resilienza Distribuita”</li>
        <li>🔵 dr. HighKali — “Governance Etica”</li>
      </ul>
    </section>

    <section class="card">
      <h2>🔊 Auditivo</h2>
      <p>Premi <strong>Play</strong> per ascoltare il riepilogo energetico.</p>
      <audio controls>
        <source src="/static/audio/crediti_energetici_intro.mp3" type="audio/mpeg">
        Il tuo browser non supporta l’audio.
      </audio>
    </section>

    <footer>
      <p class="muted">GhostTrack‑v2 © Roberto — Costellazione Etica e Resiliente</p>
    </footer>
  </div>
</body>
</html>
HTML

cat > webapp/static/gt_dark.css <<'CSS'
body {
  font-family: system-ui, sans-serif;
  background: #0f1720;
  color: #e6eef8;
  margin: 0;
  padding: 0;
}
.container {
  padding: 24px;
  max-width: 800px;
  margin: auto;
}
header {
  text-align: center;
  margin-bottom: 32px;
}
.subtitle {
  color: #9fb0c8;
  font-size: 15px;
}
.card {
  background: #0b1220;
  border: 1px solid #1f2a3a;
  padding: 18px;
  border-radius: 10px;
  margin-bottom: 20px;
}
h1, h2 {
  margin-top: 0;
}
ul {
  padding-left: 20px;
}
footer {
  text-align: center;
  margin-top: 40px;
  font-size: 13px;
  color: #9fb0c8;
}
audio {
  width: 100%;
  margin-top: 12px;
}
CSS

echo "📦 [3] Auto-aggregazione in config/modules.yaml"
yq eval '.crediti_energetici = {
  label: "Crediti Energetici",
  role: "Bilancio e riconoscimenti",
  domain: "Energia, impatto, audit",
  status: "active",
  panel: "webapp/static/panels/crediti_energetici.html",
  api: "none",
  defensive_capability: "none"
}' -i config/modules.yaml

echo "🧩 [4] Integrazione nel menu e dashboard"
MENU=ghosttrack_menu.sh
if ! grep -q 'Crediti Energetici' "$MENU"; then
  echo 'echo " [ENERGIA] Crediti Energetici → http://localhost:8000/panels/crediti_energetici.html"' >> "$MENU"
fi

DASH=dashboard.html
if [ -f "$DASH" ] && ! grep -q 'Crediti Energetici' "$DASH"; then
  sed -i '/<body>/a \
  <div class="card">\
    <h2>Crediti Energetici</h2>\
    <p>Bilancio e riconoscimenti energetici della costellazione.</p>\
    <a class="btn" href="/panels/crediti_energetici.html">Apri pannello</a>\
  </div>' "$DASH"
fi

echo "🚀 [5] Deploy su GitHub Pages"
cp webapp/static/panels/crediti_energetici.html docs/crediti_energetici.html
cp webapp/static/gt_dark.css docs/gt_dark.css
cp docs/index.html docs/404.html || true

echo "📚 [6] Commit e push"
if [ -d .git ]; then
  git add webapp/static/panels/crediti_energetici.html webapp/static/gt_dark.css docs/crediti_energetici.html docs/gt_dark.css config/modules.yaml "$MENU" "$DASH"
  git commit -m "feat: pannello Crediti Energetici completo, dark, auditivo, con deploy GitHub Pages"
  git push origin main || true
fi

echo "✅ COMPLETATO: Pannello Crediti Energetici attivo"
echo "→ http://localhost:8000/panels/crediti_energetici.html"
echo "→ GitHub Pages: docs/crediti_energetici.html"
