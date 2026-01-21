#!/bin/bash
set -e

echo "=== GhostTrack-v2 · RITUALE COMPLETO: FULL BUILD HYPEROS ==="
echo

for f in build_hyperos_enhanced.sh generate_all_docs.sh ghosttrack_sanitize_enhanced.sh ghosttrack_dashboard_sync.sh; do
  if [ ! -f "$f" ]; then
    echo "Errore: $f non trovato."
    exit 1
  fi
done

echo "[1/6] SANITIZE (dry-run)..."
bash ghosttrack_sanitize_enhanced.sh || true
echo

echo "[2/6] Pulizia reale file temporanei? (yes/no)"
read -r CLEAN_ANSWER
if [ "$CLEAN_ANSWER" = "yes" ] || [ "$CLEAN_ANSWER" = "y" ]; then
  bash ghosttrack_sanitize_enhanced.sh --clean
else
  echo "Pulizia reale saltata."
fi
echo

echo "[3/6] BUILD HYPEROS ENHANCED..."
bash build_hyperos_enhanced.sh
echo

echo "[4/6] GENERAZIONE DOCUMENTAZIONE COMPLETA..."
bash generate_all_docs.sh
echo

echo "[5/6] SYNC DASHBOARD ZDOS13..."
bash ghosttrack_dashboard_sync.sh
echo

echo "[6/6] STATO GIT FINALE:"
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
echo "=== RITUALE FULL BUILD COMPLETATO ==="
