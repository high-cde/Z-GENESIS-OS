#!/bin/bash
set -e
SNAP="webapp/static/quantum_snapshot.json"
LOG="webapp/static/quantum_log.jsonl"
python quantum/quantum_engine.py > "$SNAP"
ts=$(date -Iseconds)
echo "{\"timestamp\":\"$ts\", \"snapshot\": $(cat "$SNAP")}" >> "$LOG"
echo "Quantum snapshot aggiornato e loggato."
