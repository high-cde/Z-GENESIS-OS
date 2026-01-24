// civil-defender-wallet.js
// Civil Defender Wallet — GhostTrack-Chain (EDU)
// Modulo completo, senza demo/esecuzione automatica.
// NON per uso finanziario reale.

// ------------------------- Tipi concettuali (JSDoc) -------------------------

/**
 * @typedef {string} GhostID
 * @typedef {'CIVSTABLE'} CivTokenSymbol
 *
 * @typedef {Object} AccessContext
 * @property {string} deviceId
 * @property {string} userAgent
 * @property {string} locale
 * @property {string} timeZone
 *
 * @typedef {'DEFENSE'|'REPORT'|'INTERVENTION'|'VALIDATION'} CivilActionType
 *
 * @typedef {Object} CivilAction
 * @property {string} id
 * @property {GhostID} ghostId
 * @property {CivilActionType} type
 * @property {Object} payload
 * @property {Date} createdAt
 *
 * @typedef {Object} LedgerEntry
 * @property {string} id
 * @property {string} actionId
 * @property {GhostID} ghostId
 * @property {CivilActionType} type
 * @property {Date} timestamp
 * @property {number} rewardAmount
 * @property {CivTokenSymbol} token
 *
 * @typedef {Object} CivBalance
 * @property {GhostID} ghostId
 * @property {CivTokenSymbol} token
 * @property {number} amount
 * @property {Date} updatedAt
 *
 * @typedef {Object} CivilDefenderWalletConfig
 * @property {number} minContextScoreToWrite
 */

// ------------------------- Dipendenze -------------------------

const crypto = require('crypto');

// ------------------------- KeyManager (chiavi & GhostID) -------------------------

class KeyManager {
  constructor() {
    /** @type {{publicKey: string, privateKey: string}|null} */
    this.keyPair = null;
  }

  generateKeyPair() {
    const { publicKey, privateKey } = crypto.generateKeyPairSync('ed25519');
    const kp = {
      publicKey: publicKey.export({ type: 'spki', format: 'der' }).toString('base64'),
      privateKey: privateKey.export({ type: 'pkcs8', format: 'der' }).toString('base64'),
    };
    this.keyPair = kp;
    return kp;
  }

  loadKeyPair(privateKeyBase64, publicKeyBase64) {
    const kp = {
      publicKey: publicKeyBase64,
      privateKey: privateKeyBase64,
    };
    this.keyPair = kp;
    return kp;
  }

  getKeyPairOrThrow() {
    if (!this.keyPair) {
      throw new Error('KeyPair non inizializzato');
    }
    return this.keyPair;
  }

  /** @returns {GhostID} */
  getGhostId() {
    const { publicKey } = this.getKeyPairOrThrow();
    const hash = crypto.createHash('sha256').update(publicKey).digest('hex');
    return `GHOST-${hash}`;
  }

  sign(data) {
    const { privateKey } = this.getKeyPairOrThrow();
    const privateKeyObj = crypto.createPrivateKey({
      key: Buffer.from(privateKey, 'base64'),
      type: 'pkcs8',
      format: 'der',
    });
    const signature = crypto.sign(null, Buffer.from(data, 'utf8'), privateKeyObj);
    return signature.toString('base64');
  }

  verify(data, signatureBase64) {
    const { publicKey } = this.getKeyPairOrThrow();
    const publicKeyObj = crypto.createPublicKey({
      key: Buffer.from(publicKey, 'base64'),
      type: 'spki',
      format: 'der',
    });
    const signature = Buffer.from(signatureBase64, 'base64');
    return crypto.verify(null, Buffer.from(data, 'utf8'), publicKeyObj, signature);
  }
}

// ------------------------- ContextGuardian (contesto di accesso) -------------------------

class ContextGuardian {
  constructor() {
    /** @type {{id: string, fingerprint: string, createdAt: Date, lastUsedAt: Date}[]} */
    this.storedFingerprints = [];
  }

  /**
   * @param {AccessContext} ctx
   */
  buildFingerprint(ctx) {
    const raw = `${ctx.deviceId}|${ctx.userAgent}|${ctx.locale}|${ctx.timeZone}`;
    return crypto.createHash('sha256').update(raw).digest('hex');
  }

  /**
   * @param {AccessContext} ctx
   */
  registerContext(ctx) {
    const fingerprint = this.buildFingerprint(ctx);
    const existing = this.storedFingerprints.find((f) => f.fingerprint === fingerprint);
    if (existing) {
      existing.lastUsedAt = new Date();
      return existing;
    }
    const stored = {
      id: `CTX-${Date.now()}-${Math.random().toString(16).slice(2)}`,
      fingerprint,
      createdAt: new Date(),
      lastUsedAt: new Date(),
    };
    this.storedFingerprints.push(stored);
    return stored;
  }

  /**
   * @param {AccessContext} ctx
   */
  checkContext(ctx) {
    const fingerprint = this.buildFingerprint(ctx);
    const existing = this.storedFingerprints.find((f) => f.fingerprint === fingerprint);
    if (!existing) {
      return {
        fingerprint,
        recognized: false,
        score: 0,
      };
    }
    existing.lastUsedAt = new Date();
    return {
      fingerprint,
      recognized: true,
      score: 1,
    };
  }

  listFingerprints() {
    return [...this.storedFingerprints];
  }
}

// ------------------------- TrackLedger (azioni civili & ledger) -------------------------

class TrackLedger {
  constructor() {
    /** @type {CivilAction[]} */
    this.actions = [];
    /** @type {LedgerEntry[]} */
    this.entries = [];
  }

  /**
   * @param {GhostID} ghostId
   * @param {CivilActionType} type
   * @param {Object} payload
   * @returns {CivilAction}
   */
  registerAction(ghostId, type, payload) {
    const action = /** @type {CivilAction} */ ({
      id: `ACT-${Date.now()}-${Math.random().toString(16).slice(2)}`,
      ghostId,
      type,
      payload,
      createdAt: new Date(),
    });
    this.actions.push(action);
    return action;
  }

  /**
   * @param {CivilAction} action
   * @param {number} rewardAmount
   * @returns {LedgerEntry}
   */
  rewardAction(action, rewardAmount) {
    const entry = /** @type {LedgerEntry} */ ({
      id: `LED-${Date.now()}-${Math.random().toString(16).slice(2)}`,
      actionId: action.id,
      ghostId: action.ghostId,
      type: action.type,
      timestamp: new Date(),
      rewardAmount,
      token: 'CIVSTABLE',
    });
    this.entries.push(entry);
    return entry;
  }

  /**
   * @param {GhostID} ghostId
   * @returns {CivilAction[]}
   */
  getActionsByGhostId(ghostId) {
    return this.actions.filter((a) => a.ghostId === ghostId);
  }

  /**
   * @param {GhostID} ghostId
   * @returns {LedgerEntry[]}
   */
  getEntriesByGhostId(ghostId) {
    return this.entries.filter((e) => e.ghostId === ghostId);
  }

  getAllEntries() {
    return [...this.entries];
  }
}

// ------------------------- CivDefBank (bilanci CIVSTABLE) -------------------------

class CivDefBank {
  constructor() {
    /** @type {Map<GhostID, CivBalance>} */
    this.balances = new Map();
  }

  /**
   * @param {GhostID} ghostId
   * @returns {CivBalance}
   */
  getOrInitBalance(ghostId) {
    const existing = this.balances.get(ghostId);
    if (existing) return existing;
    const created = /** @type {CivBalance} */ ({
      ghostId,
      token: 'CIVSTABLE',
      amount: 0,
      updatedAt: new Date(),
    });
    this.balances.set(ghostId, created);
    return created;
  }

  /**
   * @param {LedgerEntry} entry
   * @returns {CivBalance}
   */
  applyLedgerEntry(entry) {
    const balance = this.getOrInitBalance(entry.ghostId);
    balance.amount += entry.rewardAmount;
    balance.updatedAt = new Date();
    this.balances.set(entry.ghostId, balance);
    return balance;
  }

  /**
   * @param {GhostID} ghostId
   * @returns {CivBalance}
   */
  getBalance(ghostId) {
    return this.getOrInitBalance(ghostId);
  }
}

// ------------------------- CivicStabilityEngine (la “stable” mai inventata) -------------------------

/**
 * Questa “stable” non è ancorata a fiat o asset esterni.
 * È un indice interno di “stabilità civile” del nodo:
 * - più azioni difensive rispetto al totale → maggiore stabilità
 * - più caos (pochi interventi difensivi) → minore stabilità
 *
 * Il valore è puramente concettuale/educativo.
 */
class CivicStabilityEngine {
  constructor() {
    this.totalActions = 0;
    this.defenseActions = 0;
  }

  /**
   * @param {CivilAction} action
   */
  registerActionForStability(action) {
    this.totalActions += 1;
    if (action.type === 'DEFENSE') {
      this.defenseActions += 1;
    }
  }

  /**
   * @returns {{stabilityIndex: number, multiplier: number}}
   */
  getStabilityState() {
    if (this.totalActions === 0) {
      return { stabilityIndex: 1, multiplier: 1 };
    }
    const ratio = this.defenseActions / this.totalActions; // 0..1
    // Indice 0.5 = neutro, >0.5 più stabile, <0.5 meno stabile
    const stabilityIndex = ratio;
    // Moltiplicatore “soft”: 0.8..1.2
    const multiplier = 0.8 + stabilityIndex * 0.4;
    return { stabilityIndex, multiplier };
  }

  /**
   * Valore “stabile” concettuale del saldo:
   * amount * multiplier, dove multiplier dipende dalla stabilità civile.
   *
   * @param {CivBalance} balance
   */
  getStableValue(balance) {
    const { multiplier } = this.getStabilityState();
    return balance.amount * multiplier;
  }
}

// ------------------------- CivilDefenderWallet (orchestratore) -------------------------

class CivilDefenderWallet {
  /**
   * @param {Partial<CivilDefenderWalletConfig>=} config
   */
  constructor(config) {
    this.keyManager = new KeyManager();
    this.contextGuardian = new ContextGuardian();
    this.ledger = new TrackLedger();
    this.bank = new CivDefBank();
    this.stabilityEngine = new CivicStabilityEngine();
    this.config = {
      minContextScoreToWrite: (config && config.minContextScoreToWrite) || 1,
    };
  }

  // --- Identità & chiavi ---

  initNewIdentity() {
    this.keyManager.generateKeyPair();
  }

  loadIdentity(privateKeyBase64, publicKeyBase64) {
    this.keyManager.loadKeyPair(privateKeyBase64, publicKeyBase64);
  }

  /** @returns {GhostID} */
  getGhostId() {
    return /** @type {GhostID} */ (this.keyManager.getGhostId());
  }

  // --- Contesto ---

  /**
   * @param {AccessContext} ctx
   */
  registerTrustedContext(ctx) {
    return this.contextGuardian.registerContext(ctx);
  }

  /**
   * @param {AccessContext} ctx
   */
  ensureContextAllowed(ctx) {
    const check = this.contextGuardian.checkContext(ctx);
    if (!check.recognized || check.score < this.config.minContextScoreToWrite) {
      throw new Error(
        'Accesso in scrittura non consentito: contesto non riconosciuto. Wallet in sola lettura.',
      );
    }
  }

  // --- Azioni civili & premi CIVSTABLE ---

  /**
   * @param {AccessContext} ctx
   * @param {CivilActionType} type
   * @param {Object} payload
   * @param {number} rewardAmount
   * @returns {{action: CivilAction, entry: LedgerEntry, balance: CivBalance}}
   */
  registerCivilAction(ctx, type, payload, rewardAmount) {
    this.ensureContextAllowed(ctx);
    const ghostId = this.getGhostId();
    const action = this.ledger.registerAction(ghostId, type, payload);
    this.stabilityEngine.registerActionForStability(action);
    const entry = this.ledger.rewardAction(action, rewardAmount);
    const balance = this.bank.applyLedgerEntry(entry);
    return { action, entry, balance };
  }

  /** @returns {CivBalance} */
  getBalance() {
    const ghostId = this.getGhostId();
    return this.bank.getBalance(ghostId);
  }

  /**
   * @returns {{actions: CivilAction[], entries: LedgerEntry[]}}
   */
  getHistory() {
    const ghostId = this.getGhostId();
    return {
      actions: this.ledger.getActionsByGhostId(ghostId),
      entries: this.ledger.getEntriesByGhostId(ghostId),
    };
  }

  // --- Firma simbolica ---

  /**
   * @param {Object} payload
   */
  signPayload(payload) {
    const data = JSON.stringify(payload);
    return this.keyManager.sign(data);
  }

  /**
   * @param {Object} payload
   * @param {string} signatureBase64
   */
  verifyPayload(payload, signatureBase64) {
    const data = JSON.stringify(payload);
    return this.keyManager.verify(data, signatureBase64);
  }

  // --- “Stable” civile ---

  /**
   * @returns {{stabilityIndex: number, multiplier: number}}
   */
  getCivicStabilityState() {
    return this.stabilityEngine.getStabilityState();
  }

  /**
   * @returns {{raw: CivBalance, stableValue: number}}
   */
  getStableBalanceView() {
    const raw = this.getBalance();
    const stableValue = this.stabilityEngine.getStableValue(raw);
    return { raw, stableValue };
  }
}

// ------------------------- Esportazioni -------------------------

module.exports = {
  KeyManager,
  ContextGuardian,
  TrackLedger,
  CivDefBank,
  CivicStabilityEngine,
  CivilDefenderWallet,
};
