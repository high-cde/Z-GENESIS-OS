#!/bin/bash

set -e

echo "=== GhostTrack-v2 · Ritual: SANITIZE REPO ==="
echo

# 1. Stato git
echo "[1/6] Stato git:"
git status -sb || echo "git status non disponibile"
echo

# 2. Verifica integrità oggetti git
echo "[2/6] Verifica integrità repository (git fsck)..."
git fsck --no-reflogs --no-progress --full || echo "Attenzione: git fsck ha segnalato problemi."
echo

# 3. Ricerca file duplicati per hash
echo "[3/6] Ricerca file duplicati per hash (può richiedere tempo)..."
TMP_HASHES="$(mktemp)"
find . -type f \
  ! -path "./.git/*" \
  ! -path "./.dvc/*" \
  ! -path "./build/*" \
  ! -path "./logs/*" \
  -print0 | xargs -0 sha1sum > "$TMP_HASHES"

echo "   - File con hash identico:"
cut -d' ' -f1 "$TMP_HASHES" | sort | uniq -d > "${TMP_HASHES}_dups" || true

if [ -s "${TMP_HASHES}_dups" ]; then
  echo "   Trovati hash duplicati. Elenco file:"
  while read -r hash; do
    echo "   Hash: $hash"
    grep "^$hash " "$TMP_HASHES" | sed 's/^/      /'
  done < "${TMP_HASHES}_dups"
else
  echo "   Nessun duplicato rilevante trovato."
fi
echo

# 4. Ricerca file temporanei / spazzatura
echo "[4/6] Ricerca file temporanei / spazzatura..."
echo "   Pattern considerati:"
echo "   - *~"
echo "   - *.swp, *.swo"
echo "   - *.tmp"
echo "   - .DS_Store"
echo "   - __pycache__/"
echo

CANDIDATES="$(mktemp)"
find . \
  \( -name "*~" -o -name "*.swp" -o -name "*.swo" -o -name "*.tmp" -o -name ".DS_Store" \) \
  ! -path "./.git/*" \
  ! -path "./.dvc/*" \
  > "$CANDIDATES"

find . -type d -name "__pycache__" \
  ! -path "./.git/*" \
  ! -path "./.dvc/*" \
  >> "$CANDIDATES"

if [ -s "$CANDIDATES" ]; then
  echo "   File/cartelle candidati alla rimozione:"
  cat "$CANDIDATES" | sed 's/^/   - /'
else
  echo "   Nessun file temporaneo rilevato."
fi
echo

# 5. Conferma rimozione
if [ -s "$CANDIDATES" ]; then
  echo "[5/6] Vuoi rimuovere questi file temporanei? (yes/no)"
  read -r ANSWER
  if [ "$ANSWER" = "yes" ] || [ "$ANSWER" = "y" ]; then
    echo "   Rimozione in corso..."
    # Prima file, poi directory
    grep -v "__pycache__" "$CANDIDATES" | xargs -r rm -f
    grep "__pycache__" "$CANDIDATES" | xargs -r rm -rf
    echo "   File temporanei rimossi."
  else
    echo "   Nessuna rimozione effettuata."
  fi
else
  echo "[5/6] Nessun candidato alla rimozione. Salto."
fi
echo

# 6. Riepilogo finale
echo "[6/6] Riepilogo:"
git status -sb || echo "git status non disponibile"
echo
echo "=== SANITIZE COMPLETATO ==="
