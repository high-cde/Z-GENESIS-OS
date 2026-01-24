// Civil Defender Wallet Panel — GhostTrack-v2 — HighKali Edition

export default {
  id: "civil_defender_wallet",
  name: "Civil Defender Wallet",
  icon: "shield",
  category: "civic",

  render: async ({ api, ui }) => {
    ui.title("Civil Defender Wallet");

    // Identità
    const ghostId = await api.wallet.getGhostId();
    ui.subtitle(`GhostID: ${ghostId}`);

    // Saldo
    ui.section("Saldo CIVSTABLE");
    const balance = await api.wallet.getStableBalanceView();
    ui.value("Raw", balance.raw.amount);
    ui.value("Stabile", balance.stableValue);

    // Azioni civiche
    ui.section("Azioni Civiche Registrate");
    const actions = await api.wallet.getActions();
    actions.forEach(a => {
      ui.item(`${a.type} — ${a.createdAt}`, JSON.stringify(a.payload));
    });

    // Pulsanti
    ui.section("Registra Nuova Azione");
    ui.button("Azione di Difesa", async () => {
      await api.wallet.registerAction("DEFENSE", { note: "Azione difensiva" }, 10);
      ui.refresh();
    });

    ui.button("Azione Civica", async () => {
      await api.wallet.registerAction("CIVIC", { note: "Azione civica" }, 5);
      ui.refresh();
    });
  }
};
