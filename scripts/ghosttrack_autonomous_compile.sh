#!/usr/bin/env bash
set -euo pipefail
cd ~/GhostTrack-v2

echo "🧼 [1] Pulizia e riavvio"
bash scripts/ghosttrack_termux_stop_full.sh || true
rm -f tmp/*.pid tmp/*.log __pycache__/* || true
find . -name '*.pyc' -delete

echo "🧩 [2] Aggregazione moduli da /api/status"
curl -s http://127.0.0.1:9090/api/status > tmp/api_status.json
MODS=$(jq -r '.modules | keys[]' tmp/api_status.json)
for mod in $MODS; do
  label=$(jq -r ".modules[\"$mod\"].description" tmp/api_status.json)
  panel="webapp/static/panels/${mod}.html"
  mkdir -p "$(dirname "$panel")"
  [ ! -f "$panel" ] && echo "<!-- Pannello placeholder per $mod -->" > "$panel"
  yq eval ".${mod} = {
    label: \"$label\",
    role: \"Modulo operativo\",
    domain: \"Costellazione\",
    status: \"active\",
    panel: \"$panel\",
    api: \"/api/$mod/query\",
    defensive_capability: \"none\"
  }" -i config/modules.yaml
done

echo "📚 [3] Integrazione voci da sidebar (screen)"
SIDEBAR_MODULES=(
  economist orchestrator wallet podcast_liberi starlink_control
  documentazione_tecnica executive_report roadmap about
  cyberdefense orbital_space agro_ambiente calcolo_ricerca radio_sdr anonimato_routing
  reti_mesh performance sistema_core moduli_estesi media_live chat_feed mappe_atlas
  resilienza_emergenza storage osservazione ai_analisi sperimentazione
)
for mod in "${SIDEBAR_MODULES[@]}"; do
  panel="webapp/static/panels/${mod}.html"
  mkdir -p "$(dirname "$panel")"
  [ ! -f "$panel" ] && echo "<!-- Pannello $mod -->" > "$panel"
  yq eval ".${mod} = {
    label: \"$mod\",
    role: \"Modulo sidebar\",
    domain: \"Interfaccia\",
    status: \"active\",
    panel: \"$panel\",
    api: \"none\",
    defensive_capability: \"none\"
  }" -i config/modules.yaml
done

echo "📊 [4] Rigenerazione dashboard"
DASH=dashboard.html
cat > "$DASH" <<'HTML'
<!doctype html><html><head><meta charset='utf-8'><title>GhostTrack Dashboard</title><link rel='stylesheet' href='/static/gt_dark.css'></head><body>
<h1>🧭 GhostTrack‑v2 — Costellazione Moduli</h1>
HTML
for mod in $(yq eval 'keys | .[]' config/modules.yaml); do
  label=$(yq eval ".${mod}.label" config/modules.yaml)
  panel=$(yq eval ".${mod}.panel" config/modules.yaml)
  echo "<div class='card'><h2>$label</h2><a class='btn' href='/$panel'>Apri pannello</a></div>" >> "$DASH"
done
echo "<footer><p class='muted'>GhostTrack‑v2 © Roberto — Sistema Operativo Etico</p></footer></body></html>" >> "$DASH"

echo "🌐 [5] Deploy GitHub Pages"
cp "$DASH" docs/index.html
cp "$DASH" docs/404.html
for mod in $(yq eval 'keys | .[]' config/modules.yaml); do
  panel=$(yq eval ".${mod}.panel" config/modules.yaml)
  cp "$panel" docs/$(basename "$panel") || true
done

echo "🧠 [6] Commit e push"
if [ -d .git ]; then
  git add config/modules.yaml dashboard.html docs/
  git commit -m "build: compilazione autonoma con moduli API, voci sidebar, dashboard e deploy"
  git push origin main || true
fi

echo "✅ GhostTrack-v2 ora include tutti i moduli API e le voci dello screen"
echo "→ Dashboard: http://localhost:8000/dashboard.html"
echo "→ GitHub Pages: docs/index.html"
