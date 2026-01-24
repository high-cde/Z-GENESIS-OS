# Aurora‑Chain  
### Coscienza Civile della Rete  
### Whitepaper v0.1

## 1. Visione

Aurora‑Chain è una blockchain progettata per portare nel mondo delle reti distribuite una logica civile, etica, verificabile, sostenibile.  
Non nasce per spremere energia o speculare, ma per coordinare, validare, proteggere e governare.

## 2. Obiettivi

**Sicurezza civile** — sicurezza basata su reputazione, integrità, partecipazione verificata.  
**Sostenibilità** — minimo consumo energetico e computazionale.  
**Trasparenza radicale** — blocchi, transazioni e governance verificabili e auditabili.  
**Partecipazione volontaria** — nessun mining nascosto, nessun uso opaco delle risorse.

## 3. Moneta nativa: AUR

**Nome:** Aurora  
**Ticker:** AUR  
**Tipo:** Utility Coin

Funzioni principali:
- staking per partecipare al consenso  
- ricompense per Civil Defender e Archivisti  
- governance on‑chain  
- accesso a moduli e servizi della rete

AUR è progettata come utility token, non come security.

## 4. Meccanismo di consenso: Proof‑of‑Integrity (PoI)

PoI combina:
- Proof‑of‑Stake (PoS)  
- Proof‑of‑Reputation (PoR)  
- Proof‑of‑Verification (PoV)

Componenti:
- **Stake:** i Civil Defender bloccano AUR.  
- **Reputazione:** cresce con validazioni corrette, uptime, assenza di comportamenti malevoli.  
- **Verifica incrociata:** blocchi proposti vengono validati da un set di Civil Defender e verificati da nodi scelti casualmente.

Flusso semplificato:
1. Un nodo propone un blocco.  
2. Civil Defender lo validano.  
3. Un sottoinsieme casuale verifica.  
4. Se il quorum PoI è raggiunto → blocco accettato.  
5. Validatori corretti ricevono AUR.  
6. Nodi malevoli perdono reputazione e parte dello stake.

## 5. Ruoli nella rete

**Interlocutore di Rete**  
- possiede un wallet AUR  
- invia/riceve transazioni  
- può partecipare alla governance (se abilitato)

**Civil Defender**  
- nodo validatore  
- mantiene una copia del ledger  
- partecipa al consenso PoI  
- riceve ricompense AUR  
- subisce slashing in caso di comportamenti malevoli

**Archivista**  
- conserva snapshot compressi della rete  
- facilita audit e sincronizzazione  
- può ricevere ricompense per servizi di archiviazione

## 6. Struttura dei blocchi

**Header:**
- hash del blocco precedente  
- root Merkle delle transazioni  
- timestamp  
- ID e firma del proponente  
- metadati PoI (stake, reputazione, quorum)

**Body:**
- lista transazioni  
- metadati di governance  
- eventuali aggiornamenti di parametri di rete

## 7. Layer architetturali

**Layer 1 — Ledger & Consenso**  
Registro distribuito, blocchi PoI, gestione chiavi e firme.

**Layer 2 — Smart‑Modules**  
Moduli sandboxati e auditabili (governance, staking, identità, audit).

**Layer 3 — Interfacce Civili**  
Wallet, explorer, pannelli di governance, API pubbliche, dashboard.

## 8. Sicurezza

- firme ECDSA/Ed25519  
- hashing SHA‑3/BLAKE3  
- anti‑Sybil tramite stake + reputazione  
- anti‑spam con fee minime e rate limiting  
- slashing per nodi malevoli  
- audit pubblici automatizzati

## 9. Governance

Governance on‑chain, trasparente, basata su AUR + reputazione.

Parametri governabili:
- dimensione blocchi  
- fee minime  
- parametri PoI (quorum, soglie, slashing)  
- allocazione ricompense  
- upgrade di protocollo

Partecipanti:
- interlocutori di rete con AUR  
- Civil Defender con reputazione sufficiente  
- eventuali comitati tecnici definiti on‑chain

## 10. Etica e linee guida

Aurora‑Chain è progettata per:
- non sfruttare risorse non consapevoli  
- non incentivare comportamenti malevoli  
- non nascondere complessità pericolose  
- non dipendere da mining ad alta intensità energetica

Implementazioni:
- richiedono consenso esplicito per l’uso delle risorse  
- devono essere open source e auditabili  
- devono rispettare le normative vigenti

## 11. Roadmap concettuale

**Fase 1 — Simulazione**  
Prototipo (es. Python/Rust), simulazione PoI, test di sicurezza.

**Fase 2 — Testnet**  
Testnet pubblica, wallet base, explorer, primi Civil Defender.

**Fase 3 — Mainnet**  
Lancio rete principale, distribuzione iniziale AUR, governance on‑chain.

**Fase 4 — Ecosistema**  
Integrazione con dashboard, moduli di identità, audit, strumenti per Civil Defender.

## 12. Conclusione

Aurora‑Chain è una proposta di blockchain civile, etica, sostenibile e governabile.  
Non vuole essere l’ennesima chain, ma una rete in cui la sicurezza è un dovere civile, non una gara di potenza.
