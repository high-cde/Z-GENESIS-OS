#!/bin/bash
set -e

REGISTRY="registry_zdos13.json"
DASHBOARD="dashboard.html"
OUT="webapp/static/zdos13_dashboard_block.html"

echo "=== GhostTrack-v2 · ZDOS13 DASHBOARD SYNC ==="

if [ ! -f "$REGISTRY" ]; then
  echo "Errore: $REGISTRY non trovato."
  exit 1
fi

mkdir -p webapp/static

echo "[1/3] Generazione blocco dashboard ZDOS13 da $REGISTRY..."

python - << 'PYEOF'
import json, os

registry_path = "registry_zdos13.json"
out_path = "webapp/static/zdos13_dashboard_block.html"

with open(registry_path, "r", encoding="utf-8") as f:
    data = json.load(f)

modules = data.get("modules", [])

menu_items = []
panels = []

for m in modules:
    name = m.get("name", "Unknown")
    key = m.get("key", name.lower().replace(" ", "_"))
    panel_file = m.get("panel", f"webapp/static/panels/zdos13/{key}.html")
    menu_items.append(f'<li><a href="#zdos13-{key}">{name}</a></li>')
    panels.append(f'<section id="zdos13-{key}">\n  <h3>{name}</h3>\n  <!-- include: {panel_file} -->\n</section>')

html = []
html.append("<!-- ZDOS13 AUTO-GENERATED BLOCK START -->")
html.append('<div class="zdos13-block">')
html.append("  <h2>ZDOS 13 · Moduli</h2>")
html.append("  <ul>")
html.extend([f"    {li}" for li in menu_items])
html.append("  </ul>")
html.extend(panels)
html.append("</div>")
html.append("<!-- ZDOS13 AUTO-GENERATED BLOCK END -->")

os.makedirs(os.path.dirname(out_path), exist_ok=True)
with open(out_path, "w", encoding="utf-8") as f:
    f.write("\n".join(html))

print(f"Generato {out_path}")
PYEOF

echo "[2/3] (Opzionale) Inserimento manuale in dashboard.html"
echo "  - Apri dashboard.html"
echo "  - Inserisci dove vuoi:"
echo '      <!--#include file="static/zdos13_dashboard_block.html" -->'
echo "    oppure copia/incolla il contenuto del blocco generato."
echo
echo "[3/3] Fatto. ZDOS13 pronto per la dashboard."
