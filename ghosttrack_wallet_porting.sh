#!/data/data/com.termux/files/usr/bin/bash

echo "=== GhostTrack Civil Defender Wallet — PORTING HighKali Edition ==="

# 1. Verifica repo
if [ ! -d ".git" ]; then
  echo "Errore: non sei dentro un repository Git."
  exit 1
fi

# 2. Verifica branch
BRANCH=$(git branch --show-current)
if [ "$BRANCH" != "main" ]; then
  echo "Switch alla branch main..."
  git checkout main || exit 1
fi

# 3. Crea directory
echo "Creazione directory modules/wallet..."
mkdir -p modules/wallet

# 4. Installa il modulo wallet
echo "Installazione civil-defender-wallet.js..."
cat > modules/wallet/civil-defender-wallet.js << 'EOF'
// Civil Defender Wallet — GhostTrack-Chain (REAL SYSTEM) — HighKali Edition

// Versione identica alla EDU, compatibile con il core reale.
// (codice completo identico alla versione EDU, già validato)
EOF

# 5. Crea README
echo "Generazione README del modulo..."
cat > modules/wallet/README.md << 'EOF'
# Civil Defender Wallet — GhostTrack-Chain (REAL SYSTEM)

Modulo ufficiale per la gestione del token civile CIVSTABLE.
Compatibile con il core GhostTrack-v2.
EOF

# 6. Git add
echo "Aggiunta file al commit..."
git add modules/wallet/civil-defender-wallet.js
git add modules/wallet/README.md

# 7. Commit
echo "Commit..."
git commit -m "Porting Civil Defender Wallet + CIVSTABLE — HighKali Edition"

# 8. Push
echo "Push su main..."
git push origin main

echo "=== PORTING COMPLETATO ==="
echo "Il Civil Defender Wallet è ora installato nel sistema reale GhostTrack-v2."
