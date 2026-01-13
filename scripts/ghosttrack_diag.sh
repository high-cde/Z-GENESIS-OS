#!/usr/bin/env bash
set -euo pipefail
cd ~/GhostTrack-v2

echo "🔍 Diagnostica GhostTrack-v2"
echo "→ User: $(whoami)"
echo "→ Shell: $SHELL"
echo "→ Python: $(which python3)"
echo "→ Virtualenv attivo: $VIRTUAL_ENV"
echo "→ yq: $(which yq || echo '❌ yq non trovato')"
echo "→ Git branch: $(git rev-parse --abbrev-ref HEAD || echo 'non git')"
echo "→ Ultimo commit:"
git log -1 --oneline || echo "no commit"

echo "→ Moduli dichiarati:"
yq eval 'keys' config/modules.yaml || echo "config/modules.yaml mancante"

echo "→ Pannelli mancanti:"
for mod in $(yq eval 'keys | .[]' config/modules.yaml); do
  panel=$(yq eval ".${mod}.panel" config/modules.yaml)
  [ ! -f "$panel" ] && echo "❌ $mod → manca $panel"
done

echo "→ Dashboard preview:"
head -n 10 dashboard.html || echo "dashboard.html mancante"
