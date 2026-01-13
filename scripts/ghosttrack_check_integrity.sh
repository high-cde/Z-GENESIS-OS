#!/usr/bin/env bash
set -euo pipefail
cd ~/GhostTrack-v2

echo "🔍 Verifica integrità GhostTrack-v2"

# 1. Virtualenv
echo "→ Virtualenv attivo: ${VIRTUAL_ENV:-❌ non attivo}"

# 2. Moduli
echo "→ Moduli dichiarati:"
if [ -f config/modules.yaml ]; then
  yq eval 'keys' config/modules.yaml
else
  echo "❌ config/modules.yaml mancante"
fi

# 3. Pannelli
echo "→ Verifica pannelli:"
for mod in $(yq eval 'keys | .[]' config/modules.yaml); do
  panel=$(yq eval ".${mod}.panel" config/modules.yaml)
  if [ -f "$panel" ]; then
    echo "✔️ $mod → $panel OK"
  else
    echo "❌ $mod → pannello mancante: $panel"
  fi
done

# 4. Dashboard
echo "→ Dashboard:"
[ -f dashboard.html ] && echo "✔️ dashboard.html OK" || echo "❌ dashboard.html mancante"

# 5. API status
echo "→ API /status:"
curl -s http://127.0.0.1:9090/api/status | jq . || echo "❌ API non raggiungibile"

# 6. GitHub Pages
echo "→ GitHub Pages deploy:"
[ -f docs/index.html ] && echo "✔️ docs/index.html OK" || echo "❌ docs/index.html mancante"
[ -f docs/404.html ] && echo "✔️ docs/404.html OK" || echo "❌ docs/404.html mancante"

# 7. Ledger & Wallet
echo "→ Ledger & Wallet:"
[ -f wallet/address.txt ] && echo "✔️ wallet/address.txt OK" || echo "❌ wallet/address.txt mancante"
[ -f wallet/seed.txt ] && echo "✔️ wallet/seed.txt OK" || echo "❌ wallet/seed.txt mancante"
[ -f wallet/passhare.txt ] && echo "✔️ wallet/passhare.txt OK" || echo "❌ wallet/passhare.txt mancante"
[ -f ledger/contract_energy.json ] && echo "✔️ ledger/contract_energy.json OK" || echo "❌ ledger/contract_energy.json mancante"

# 8. Favicon & CSS
echo "→ Favicon & CSS:"
[ -f webapp/static/gt_dark.css ] && echo "✔️ gt_dark.css OK" || echo "❌ gt_dark.css mancante"
[ -f webapp/static/favicon_energy.ico ] && echo "✔️ favicon_energy.ico OK" || echo "❌ favicon_energy.ico mancante"

# 9. Audio
echo "→ Audio:"
[ -f webapp/static/audio/crediti_energetici_intro.mp3 ] && echo "✔️ audio OK" || echo "⚠️ audio mancante (opzionale)"

# 10. Git status
echo "→ Git:"
git status -s || echo "❌ repo non inizializzato"

echo "✅ Verifica completata"
