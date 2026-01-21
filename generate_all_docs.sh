#!/bin/bash

echo "[1/6] Creazione cartella wiki..."
mkdir -p wiki

echo "[2/6] Creazione README_TECH.md..."
cat > README_TECH.md << 'MD1'
# GhostTrack‑v2 · HyperOS Tecnico · ZDOS 13 Stack

## 1. Architettura HyperOS
- Technical Layer
- Energetic Layer
- Cognitive Layer
- Quantum Layer
- Synthetic Layer

## 2. ZDOS 13 — Tech Stack
Stack definito in zdos13_tech.py.

## 3. File principali
- zdos13_tech.py
- zdos13.conf
- registry_zdos13.json
- cli/gt_zdos13.py
- webapp/static/panels/zdos13/

## 4. Pipeline di build
1. Scan Cognitivo  
2. Analisi Energetica  
3. Compilazione Tecnica  
4. Sintesi Quantica  
5. Ottimizzazione Sintetica  
6. Validazione Ledger  
7. Firma Cognitiva  

## 5. Governance Cognitiva
- Cognitive Watchdog  
- Ethical Pulse Monitor  
- Autonomous Decision Layer  
- Cognitive Resonance Engine  
- Integrity Drift Stabilizer  

## 6. CLI interna
- gt_zdos13 list

## 7. Struttura cartelle
GhostTrack-v2-edu/
├── zdos13_tech.py
├── zdos13.conf
├── registry_zdos13.json
├── cli/
│   └── gt_zdos13.py
└── webapp/
    └── static/
        └── panels/
            └── zdos13/
MD1

echo "[3/6] Creazione MANUALE_ZDOS13.md..."
cat > MANUALE_ZDOS13.md << 'MD2'
# Manuale ZDOS 13 · GhostTrack‑v2

## 1. Introduzione
ZDOS 13 è il Research Lab integrato in GhostTrack‑v2.

## 2. Requisiti
- Python 3
- File generati:
  - zdos13_tech.py
  - zdos13.conf
  - registry_zdos13.json
  - cli/gt_zdos13.py
  - pannelli UI

## 3. Uso base
python zdos13_tech.py  
python cli/gt_zdos13.py list  

## 4. Configurazione
Modifica zdos13.conf.

## 5. Registry
registry_zdos13.json è usato da UI, API, CLI.

## 6. Pannelli UI
webapp/static/panels/zdos13/

## 7. Dashboard
La dashboard può leggere il registry.

## 8. Estensioni future
- CLI avanzata  
- ledger  
- pannelli dinamici  

## 9. Filosofia operativa
ZDOS 13 è un’estensione cognitiva dell’HyperOS.
MD2

echo "[4/6] Generazione pagine Wiki..."

# Home
cat > wiki/Home.md << 'W1'
# GhostTrack‑v2 · HyperOS · Wiki Ufficiale
Documentazione completa del sistema HyperOS e del Research Lab ZDOS 13.
W1

# Architettura
cat > wiki/Architettura-HyperOS.md << 'W2'
# Architettura HyperOS
5 layer: Technical, Energetic, Cognitive, Quantum, Synthetic.
W2

# ZDOS13
cat > wiki/ZDOS13-Tech-Stack.md << 'W3'
# ZDOS 13 — Tech Stack
Stack completo definito in zdos13_tech.py.
W3

# Moduli e Layer
cat > wiki/Moduli-e-Layer.md << 'W4'
# Moduli e Layer
Ogni tecnologia ZDOS13 è un modulo organizzato per layer.
W4

# Pipeline
cat > wiki/Pipeline-di-Build.md << 'W5'
# Pipeline di Build HyperOS
7 fasi: Scan Cognitivo → Firma Cognitiva.
W5

# Governance
cat > wiki/Governance-Cognitiva.md << 'W6'
# Governance Cognitiva
Cognitive Watchdog, Ethical Pulse Monitor, Decision Layer.
W6

# CLI
cat > wiki/CLI-Interna.md << 'W7'
# CLI Interna
Comando principale: gt_zdos13 list.
W7

# Configurazioni
cat > wiki/Configurazioni.md << 'W8'
# Configurazioni
zdos13.conf controlla lo stato dei moduli.
W8

# Registry
cat > wiki/Registry.md << 'W9'
# Registry
registry_zdos13.json è la mappa dei moduli.
W9

# Pannelli UI
cat > wiki/Pannelli-UI.md << 'W10'
# Pannelli UI
Ogni modulo ha un pannello in webapp/static/panels/zdos13/.
W10

# Roadmap
cat > wiki/Roadmap.md << 'W11'
# Roadmap
- Dashboard avanzata
- CLI estesa
- Ledger energetico
- API interne
W11

# Glossario
cat > wiki/Glossario.md << 'W12'
# Glossario
HyperOS, ZDOS13, Ledger Energetico, Quantum Layer, Synthetic Layer.
W12

echo "[5/6] Aggiunta file a git..."
git add README_TECH.md MANUALE_ZDOS13.md wiki/

echo "[6/6] Completato!"
echo "Ora puoi fare:"
echo "  git commit -m \"Documentazione completa ZDOS13 + Wiki\""
echo "  git push"
