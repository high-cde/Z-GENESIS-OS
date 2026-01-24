#!/bin/bash
set -e

LOGDIR="logs"
mkdir -p "$LOGDIR"
LOGFILE="$LOGDIR/ghosttrack_sanitize_enhanced_$(date +%Y%m%d_%H%M%S).log"

echo "=== GhostTrack-v2 · SANITIZE ENHANCED ===" | tee -a "$LOGFILE"

# Uso
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  cat <<USAGE
Uso:
  bash ghosttrack_sanitize_enhanced.sh        # dry-run (solo analisi)
  bash ghosttrack_sanitize_enhanced.sh --clean
  bash ghosttrack_sanitize_enhanced.sh --dedupe
  bash ghosttrack_sanitize_enhanced.sh --force-add-build
  bash ghosttrack_sanitize_enhanced.sh --clean --dedupe
USAGE
  exit 0
fi

echo "[1] git status (short)" | tee -a "$LOGFILE"
git status -sb | tee -a "$LOGFILE" || echo "git status non disponibile" | tee -a "$LOGFILE"
echo "" | tee -a "$LOGFILE"

echo "[2] git integrity check (git fsck)" | tee -a "$LOGFILE"
if git rev-parse --git-dir > /dev/null 2>&1; then
  git fsck --no-reflogs --no-progress --full 2>&1 | tee -a "$LOGFILE" || true
else
  echo "Non è una repo git valida." | tee -a "$LOGFILE"
fi
echo "" | tee -a "$LOGFILE"

TMP_HASHES="$(mktemp)"
find . -type f \
  ! -path "./.git/*" \
  ! -path "./.dvc/*" \
  ! -path "./build/*" \
  ! -path "./logs/*" \
  -print0 | xargs -0 sha1sum > "$TMP_HASHES"

echo "[3] Duplicati per hash (elenco)" | tee -a "$LOGFILE"
cut -d' ' -f1 "$TMP_HASHES" | sort | uniq -d > "${TMP_HASHES}_dups" || true

if [ -s "${TMP_HASHES}_dups" ]; then
  echo "Trovati hash duplicati:" | tee -a "$LOGFILE"
  while read -r hash; do
    echo "Hash: $hash" | tee -a "$LOGFILE"
    grep "^$hash " "$TMP_HASHES" | sed 's/^/  /' | tee -a "$LOGFILE"
  done < "${TMP_HASHES}_dups"
else
  echo "Nessun duplicato rilevato." | tee -a "$LOGFILE"
fi
echo "" | tee -a "$LOGFILE"

echo "[4] File temporanei e cache" | tee -a "$LOGFILE"
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
  echo "File/cartelle candidati:" | tee -a "$LOGFILE"
  sed 's/^/  /' "$CANDIDATES" | tee -a "$LOGFILE"
else
  echo "Nessun file temporaneo trovato." | tee -a "$LOGFILE"
fi
echo "" | tee -a "$LOGFILE"

if echo "$@" | grep -q -- "--dedupe"; then
  if [ -s "${TMP_HASHES}_dups" ]; then
    echo "[5] Dedupe: rimozione duplicati (lascia il primo file per hash)" | tee -a "$LOGFILE"
    while read -r hash; do
      files=( $(grep "^$hash " "$TMP_HASHES" | awk '{print $2}') )
      echo "Hash: $hash" | tee -a "$LOGFILE"
      for i in "${!files[@]}"; do
        echo "  [$i] ${files[$i]}" | tee -a "$LOGFILE"
      done
      echo "Vuoi rimuovere i duplicati lasciando il file [0]? (yes/no)"
      read -r ans
      if [ "$ans" = "yes" ] || [ "$ans" = "y" ]; then
        for idx in "${!files[@]}"; do
          if [ "$idx" -ne 0 ]; then
            rm -f "${files[$idx]}"
            echo "  Rimosso ${files[$idx]}" | tee -a "$LOGFILE"
          fi
        done
      else
        echo "  Saltato per questo hash." | tee -a "$LOGFILE"
      fi
    done < "${TMP_HASHES}_dups"
  else
    echo "Nessun duplicato da processare." | tee -a "$LOGFILE"
  fi
  echo "" | tee -a "$LOGFILE"
fi

if echo "$@" | grep -q -- "--clean"; then
  if [ -s "$CANDIDATES" ]; then
    echo "[6] Pulizia file temporanei e __pycache__" | tee -a "$LOGFILE"
    echo "Confermi rimozione? (yes/no)"
    read -r ans2
    if [ "$ans2" = "yes" ] || [ "$ans2" = "y" ]; then
      grep -v "__pycache__" "$CANDIDATES" | xargs -r rm -f
      grep "__pycache__" "$CANDIDATES" | xargs -r rm -rf
      echo "Rimozione completata." | tee -a "$LOGFILE"
    else
      echo "Pulizia annullata." | tee -a "$LOGFILE"
    fi
  else
    echo "Nessun file temporaneo da rimuovere." | tee -a "$LOGFILE"
  fi
  echo "" | tee -a "$LOGFILE"
fi

if echo "$@" | grep -q -- "--force-add-build"; then
  echo "[7] Forzatura aggiunta build/ e logs/ a git" | tee -a "$LOGFILE"
  git add -f build/ logs/ || echo "git add -f fallito o non necessario" | tee -a "$LOGFILE"
  echo "Aggiunta forzata eseguita (verifica con git status)." | tee -a "$LOGFILE"
  echo "" | tee -a "$LOGFILE"
fi

echo "[8] File non tracciati (untracked)" | tee -a "$LOGFILE"
git ls-files --others --exclude-standard | tee -a "$LOGFILE" || true
echo "" | tee -a "$LOGFILE"

echo "=== SANITIZE ENHANCED COMPLETATO ===" | tee -a "$LOGFILE"
echo "Log salvato in: $LOGFILE"
