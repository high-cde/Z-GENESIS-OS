#!/usr/bin/env bash
set -euo pipefail
cd ~/GhostTrack-v2

echo "🔁 [1] Pulizia e riavvio"
bash scripts/ghosttrack_termux_stop_full.sh || true
rm -f tmp/*.pid tmp/*.log __pycache__/* || true
find . -name '*.pyc' -delete

echo "📦 [2] Verifica moduli e pannelli"
MODS=$(yq eval 'keys | .[]' config/modules.yaml)
for mod in $MODS; do
  panel=$(yq eval ".${mod}.panel" config/modules.yaml)
  if [ ! -f "$panel" ]; then
    echo "⚠️  Pannello mancante per $mod → $panel"
    mkdir -p "$(dirname "$panel")"
    echo "<!-- Pannello placeholder per $mod -->" > "$panel"
  fi
done

echo "📚 [3] Ricostruzione dashboard con stato API e ambiente"
DASH=dashboard.html
cat > "$DASH" <<'HTML'
<!doctype html>
<html lang="it">
<head>
  <meta charset="utf-8">
  <title>GhostTrack Console</title>
  <link rel="stylesheet" href="/static/gt_dark.css">
  <script defer src="/static/gt_status.js"></script>
</head>
<body>
<div class="gt-dashboard">
  <section class="gt-section gt-section-main">
    <h1>GhostTrack Console</h1>
    <p class="gt-subtitle">Costellazione operativa · Versione 3.0 · Nodo locale</p>
    <div class="gt-status-row">
      <div class="gt-status-card" id="gt-api-status-card">
        <h2>Stato API</h2>
        <p class="gt-status-line">
          <span class="gt-pill" id="gt-api-pill">SENSORE</span>
          <span id="gt-api-status-text">In attesa…</span>
        </p>
        <p class="gt-status-meta" id="gt-api-meta"></p>
      </div>
      <div class="gt-status-card">
        <h2>Ambiente</h2>
        <p class="gt-status-line">
          <span class="gt-pill gt-pill-env" id="gt-env-pill">Sconosciuto</span>
        </p>
        <ul class="gt-meta-list">
          <li><strong>Host:</strong> <span id="gt-env-host"></span></li>
          <li><strong>Base API:</strong> <span id="gt-env-base-url"></span></li>
        </ul>
      </div>
    </div>
  </section>
HTML

for mod in $MODS; do
  label=$(yq eval ".${mod}.label" config/modules.yaml)
  panel=$(yq eval ".${mod}.panel" config/modules.yaml)
  echo "<section class='gt-section'><h2>$label</h2><a class='btn' href='/$panel'>Apri pannello</a></section>" >> "$DASH"
done

echo "<footer><p class='muted'>GhostTrack‑v2 © Roberto — Sistema Operativo Etico</p></footer></div></body></html>" >> "$DASH"

echo "🔗 [4] Verifica API /status"
curl -s http://127.0.0.1:9090/api/status | jq . || echo "⚠️ API non raggiungibile"

echo "🌐 [5] Deploy GitHub Pages"
cp "$DASH" docs/index.html
cp "$DASH" docs/404.html
for mod in $MODS; do
  panel=$(yq eval ".${mod}.panel" config/modules.yaml)
  cp "$panel" docs/$(basename "$panel") || true
done

echo "🧠 [6] Commit e push"
if [ -d .git ]; then
  git add config/modules.yaml dashboard.html docs/
  git commit -m "build: compilazione completa GhostTrack OS con dashboard, moduli, stato API e deploy"
  git push origin main || true
fi

echo "✅ GhostTrack-v2 ora è un sistema operativo coerente, compilato e pubblicato"
echo "→ Dashboard: http://localhost:8000/dashboard.html"
echo "→ GitHub Pages: docs/index.html"
