#!/bin/bash
set -e

echo "=== GHOSTTRACK · FIX LINK GITHUB PAGES ==="

# 1) Correggi link assoluti in TUTTI gli HTML
echo "[1] Correzione percorsi assoluti → relativi"
find . -name "*.html" -type f | while read f; do
  sed -i 's|href="/|href="|g' "$f"
  sed -i 's|src="/|src="|g' "$f"
  sed -i 's|href="static/|href="webapp/static/|g' "$f"
  sed -i 's|src="static/|src="webapp/static/|g' "$f"
  sed -i 's|href="/static/|href="webapp/static/|g' "$f"
  sed -i 's|src="/static/|src="webapp/static/|g' "$f"
  sed -i 's|href="/webapp/|href="webapp/|g' "$f"
  sed -i 's|src="/webapp/|src="webapp/|g' "$f"
done

# 2) Correggi link ai pannelli
echo "[2] Correzione pannelli"
find . -name "*.html" -type f | while read f; do
  sed -i 's|href="panels/|href="webapp/static/panels/|g' "$f"
  sed -i 's|src="panels/|src="webapp/static/panels/|g' "$f"
done

# 3) Correggi link ai docs
echo "[3] Correzione docs"
find . -name "*.html" -type f | while read f; do
  sed -i 's|href="/docs/|href="docs/|g' "$f"
  sed -i 's|src="/docs/|src="docs/|g' "$f"
done

# 4) Correggi link a file JS/CSS
echo "[4] Correzione JS/CSS"
find . -name "*.html" -type f | while read f; do
  sed -i 's|src="/js/|src="js/|g' "$f"
  sed -i 's|href="/css/|href="css/|g' "$f"
done

# 5) Commit e push
echo "[5] Commit & Push"
git add .
git commit -m "Fix link per GitHub Pages (percorsi relativi)"
git push

echo "=== FIX COMPLETATO ==="
echo "Ora i link funzionano su GitHub Pages."
