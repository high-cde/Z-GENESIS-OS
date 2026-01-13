#!/usr/bin/env bash
set -euo pipefail
cd ~/GhostTrack-v2

echo "🔁 [1] Pulizia e riavvio"
bash scripts/ghosttrack_termux_stop_full.sh || true
rm -f tmp/*.pid tmp/*.log __pycache__/* || true
find . -name '*.pyc' -delete

echo "📦 [2] Sincronizzazione moduli"
MODS=$(yq eval 'keys | .[]' config/modules.yaml)
for mod in $MODS; do
  panel=$(yq eval ".${mod}.panel" config/modules.yaml)
  if [ ! -f "$panel" ]; then
    echo "⚠️  Pannello mancante per $mod → $panel"
    mkdir -p "$(dirname "$panel")"
    echo "<!-- Placeholder per $mod -->" > "$panel"
  fi
done

echo "📚 [3] Rigenerazione dashboard"
DASH=dashboard.html
echo "<!doctype html><html><head><meta charset='utf-8'><title>GhostTrack Dashboard</title><link rel='stylesheet' href='/static/gt_dark.css'></head><body>" > "$DASH"
echo "<h1>🧭 GhostTrack‑v2 — Costellazione Moduli</h1>" >> "$DASH"
for mod in $MODS; do
  label=$(yq eval ".${mod}.label" config/modules.yaml)
  panel=$(yq eval ".${mod}.panel" config/modules.yaml)
  echo "<div class='card'><h2>$label</h2><a class='btn' href='/$panel'>Apri pannello</a></div>" >> "$DASH"
done
echo "<footer><p class='muted'>GhostTrack‑v2 © Roberto</p></footer></body></html>" >> "$DASH"

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
  git commit -m "chore: super sync — moduli, dashboard, deploy GitHub Pages"
  git push origin main || true
fi

echo "✅ Super sync completato. Dashboard: http://localhost:8000/dashboard.html"
