#!/usr/bin/env bash
set -euo pipefail
cd ~/GhostTrack-v2

echo "🧼 [1] Pulizia generale"
bash scripts/ghosttrack_termux_stop_full.sh || true
rm -f tmp/*.pid tmp/*.log __pycache__/* || true
find . -name '*.pyc' -delete

echo "🔍 [2] Analisi struttura repo"
echo "→ Cartelle principali:"
ls -d */ | grep -v '^tmp' | grep -v '^__pycache__'
echo "→ Moduli dichiarati:"
yq eval '.' config/modules.yaml || echo "config/modules.yaml mancante"

echo "🧩 [3] Verifica coerenza moduli"
for mod in $(yq eval 'keys | .[]' config/modules.yaml); do
  panel=$(yq eval ".${mod}.panel" config/modules.yaml)
  if [ -f "$panel" ]; then
    echo "✔️ Modulo $mod: pannello OK → $panel"
  else
    echo "❌ Modulo $mod: pannello mancante → $panel"
    touch "$panel"
    echo "<!-- Pannello placeholder per $mod -->" > "$panel"
  fi
done

echo "📚 [4] Rigenerazione dashboard"
DASH=dashboard.html
echo "<!doctype html><html><head><meta charset='utf-8'><title>GhostTrack Dashboard</title><link rel='stylesheet' href='/static/gt_dark.css'></head><body>" > "$DASH"
echo "<h1>🧭 GhostTrack‑v2 — Costellazione Moduli</h1>" >> "$DASH"
for mod in $(yq eval 'keys | .[]' config/modules.yaml); do
  label=$(yq eval ".${mod}.label" config/modules.yaml)
  panel=$(yq eval ".${mod}.panel" config/modules.yaml)
  echo "<div class='card'><h2>$label</h2><a class='btn' href='/$panel'>Apri pannello</a></div>" >> "$DASH"
done
echo "<footer><p class='muted'>GhostTrack‑v2 © Roberto</p></footer></body></html>" >> "$DASH"

echo "🔗 [5] Verifica API /status"
curl -s http://127.0.0.1:9090/api/status | jq . || echo "⚠️ API non raggiungibile"

echo "📦 [6] Deploy GitHub Pages"
cp "$DASH" docs/index.html
cp "$DASH" docs/404.html
for mod in $(yq eval 'keys | .[]' config/modules.yaml); do
  panel=$(yq eval ".${mod}.panel" config/modules.yaml)
  cp "$panel" docs/$(basename "$panel") || true
done

echo "🧠 [7] Commit finale"
if [ -d .git ]; then
  git add config/modules.yaml dashboard.html docs/
  git commit -m "chore: repo allineato, moduli verificati, dashboard rigenerata"
  git push origin main || true
fi

echo "✅ Repo allineato e coerente. Dashboard: http://localhost:8000/dashboard.html"
