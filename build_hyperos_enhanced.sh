#!/bin/bash
set -e

echo "=== GhostTrack-v2 · HyperOS Build ENHANCED ==="

if [ ! -f "zdos13_tech.py" ] || [ ! -f "zdos13.conf" ] || [ ! -f "registry_zdos13.json" ]; then
  echo "Prerequisiti ZDOS13 mancanti."
  exit 1
fi

mkdir -p build logs

BUILD_ID="$(date +%Y%m%d_%H%M%S)"
BUILD_LOG="logs/build_hyperos_${BUILD_ID}.log"
VERSION_FILE="build/hyperos_version.txt"
SNAPSHOT_FILE="build/hyperos_snapshot_${BUILD_ID}.txt"

echo "[1/7] Versioning..." | tee -a "$BUILD_LOG"
if [ -f "$VERSION_FILE" ]; then
  CURR=$(cat "$VERSION_FILE")
  NEXT=$((CURR + 1))
else
  NEXT=1
fi
echo "$NEXT" > "$VERSION_FILE"
echo "Versione HyperOS: $NEXT" | tee -a "$BUILD_LOG"

echo "[2/7] Scan Cognitivo..." | tee -a "$BUILD_LOG"
echo "Verifica base file ZDOS13." | tee -a "$BUILD_LOG"

echo "[3/7] Compilazione Tecnica (zdos13_tech.py)..." | tee -a "$BUILD_LOG"
python zdos13_tech.py > build/zdos13_modules.txt
echo "Generato build/zdos13_modules.txt" | tee -a "$BUILD_LOG"

echo "[4/7] Snapshot esteso..." | tee -a "$BUILD_LOG"
{
  echo "HyperOS Build Snapshot"
  echo "Build ID: $BUILD_ID"
  echo "Version: $NEXT"
  echo
  echo "=== git status ==="
  git status -sb || echo "git status non disponibile"
  echo
  echo "=== ZDOS13 Modules ==="
  cat build/zdos13_modules.txt
} > "$SNAPSHOT_FILE"
echo "Generato $SNAPSHOT_FILE" | tee -a "$BUILD_LOG"

echo "[5/7] Hash principali..." | tee -a "$BUILD_LOG"
sha256sum zdos13_tech.py zdos13.conf registry_zdos13.json >> "$BUILD_LOG" 2>/dev/null || true

echo "[6/7] Placeholder Energetic/Quantum/Synthetic..." | tee -a "$BUILD_LOG"
echo "Energetic/Quantum/Synthetic: integrazione futura." | tee -a "$BUILD_LOG"

echo "[7/7] Firma Cognitiva..." | tee -a "$BUILD_LOG"
echo "dr. HighKali: build $BUILD_ID v$NEXT marcata coerente." | tee -a "$BUILD_LOG"

echo "Artefatti:"
echo "  - $VERSION_FILE"
echo "  - build/zdos13_modules.txt"
echo "  - $SNAPSHOT_FILE"
echo "  - $BUILD_LOG"
