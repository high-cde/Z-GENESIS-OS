#!/bin/bash
set -e

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"

echo "=== GhostTrack-v2 · RITUALE GLOBALE: MASTER HYPEROS ==="
echo

# Check essentials
for f in ghosttrack_sanitize_enhanced.sh build_hyperos_enhanced.sh generate_all_docs.sh ghosttrack_dashboard_sync.sh; do
  if [ ! -f "$f" ]; then
    echo "Errore: file richiesto non trovato: $f"
    exit 1
  fi
done

# 1) SANITIZE (dry-run + opzionale clean)
echo "[1/7] SANITIZE (dry-run)..."
bash ghosttrack_sanitize_enhanced.sh || true
echo

echo "[1b/7] Pulizia reale file temporanei? (yes/no)"
read -r CLEAN_ANSWER
if [ "$CLEAN_ANSWER" = "yes" ] || [ "$CLEAN_ANSWER" = "y" ]; then
  bash ghosttrack_sanitize_enhanced.sh --clean
else
  echo "Pulizia reale saltata."
fi
echo

# 2) BUILD HYPEROS ENHANCED
echo "[2/7] BUILD HYPEROS ENHANCED..."
bash build_hyperos_enhanced.sh
echo

# 3) GENERAZIONE DOCUMENTAZIONE + WIKI
echo "[3/7] GENERAZIONE DOCUMENTAZIONE COMPLETA..."
bash generate_all_docs.sh
echo

# 4) DASHBOARD SYNC (base)
echo "[4/7] SYNC DASHBOARD ZDOS13 (base)..."
bash ghosttrack_dashboard_sync.sh
echo

# 5) DASHBOARD MENU AVANZATO (dinamico)
echo "[5/7] GENERAZIONE MENU AVANZATO ZDOS13 PER DASHBOARD..."

python - << 'PYEOF'
import json, os

registry_path = "registry_zdos13.json"
menu_out = "webapp/static/zdos13_menu_advanced.html"

if not os.path.exists(registry_path):
    print(f"Registry {registry_path} non trovato.")
    raise SystemExit(1)

with open(registry_path, "r", encoding="utf-8") as f:
    data = json.load(f)

modules = data.get("modules", [])

html = []
html.append("<!-- ZDOS13 ADVANCED MENU START -->")
html.append('<nav class="zdos13-menu-advanced">')
html.append('  <h2>ZDOS 13 · Moduli Attivi</h2>')
html.append('  <ul>')
for m in modules:
    name = m.get("name", "Unknown")
    key = m.get("key", name.lower().replace(" ", "_"))
    status = m.get("enabled", True)
    cls = "enabled" if status else "disabled"
    html.append(f'    <li class="{cls}"><a href="#zdos13-{key}">{name}</a></li>')
html.append('  </ul>')
html.append('</nav>')
html.append("<!-- ZDOS13 ADVANCED MENU END -->")

os.makedirs(os.path.dirname(menu_out), exist_ok=True)
with open(menu_out, "w", encoding="utf-8") as f:
    f.write("\n".join(html))

print(f"Generato {menu_out}")
PYEOF

echo

# 6) QUANTUM LAYER BOOTSTRAP (placeholder operativo)
echo "[6/7] QUANTUM LAYER BOOTSTRAP..."

mkdir -p quantum
cat > quantum/quantum_layer_manifest.json << 'QEOF'
{
  "layer": "Quantum",
  "status": "initialized",
  "components": [
    "Q-Link Protocol",
    "Sub-Quantum Identity Anchor",
    "Quantum Resonance Amplifier",
    "Multi-Reality Sync Engine"
  ],
  "notes": "Bootstrap iniziale Quantum Layer. Integrazione logica futura con ZDOS13 registry e HyperOS snapshot."
}
QEOF

echo "Creato quantum/quantum_layer_manifest.json"
echo

# 7) STATO GIT + COMMIT/PUSH INTERATTIVO
echo "[7/7] STATO GIT FINALE:"
git status -sb
echo

echo "Vuoi procedere con il commit ora? (yes/no)"
read -r COMMIT_ANSWER
if [ "$COMMIT_ANSWER" = "yes" ] || [ "$COMMIT_ANSWER" = "y" ]; then
  echo "Inserisci il messaggio di commit (una riga):"
  read -r COMMIT_MSG
  git add .
  git commit -m "$COMMIT_MSG"
  echo "Vuoi fare anche il push? (yes/no)"
  read -r PUSH_ANSWER
  if [ "$PUSH_ANSWER" = "yes" ] || [ "$PUSH_ANSWER" = "y" ]; then
    git push
  else
    echo "Push saltato. Puoi farlo dopo con: git push"
  fi
else
  echo "Commit saltato. Puoi committare manualmente dopo."
fi

echo
echo "=== RITUALE MASTER COMPLETATO ==="
echo

# Alias gt full
SHELL_RC="$HOME/.bashrc"
if [ -n "$ZSH_VERSION" ]; then
  SHELL_RC="$HOME/.zshrc"
fi

if ! grep -q "alias gt_full=" "$SHELL_RC" 2>/dev/null; then
  echo "Configurazione alias gt_full in $SHELL_RC"
  echo "alias gt_full='bash \"$ROOT_DIR/ghosttrack_master.sh\"'" >> "$SHELL_RC"
  echo "Alias gt_full aggiunto. Riapri la shell o esegui: source $SHELL_RC"
else
  echo "Alias gt_full già presente in $SHELL_RC"
fi

bash ghosttrack_quantum_sync.sh
