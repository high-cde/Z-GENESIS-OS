const star = document.getElementById("rza-star");
const panel = document.getElementById("rza-bot-panel");
const portal = document.getElementById("rza-portal");
const field = document.getElementById("quantum-field");

star.addEventListener("click", () => {
  portal.style.animation = "none";
  void portal.offsetWidth;
  portal.style.animation = "portalExpand 0.6s ease-out forwards";
  panel.classList.remove("hidden");
});

panel.addEventListener("click", (e) => {
  if (e.target === panel) {
    panel.classList.add("hidden");
  }
});

/* Particelle orbitanti */
const particles = 60;

for (let i = 0; i < particles; i++) {
  const p = document.createElement("div");
  p.className = "quantum-particle";
  p.style.position = "absolute";
  p.style.width = "4px";
  p.style.height = "4px";
  p.style.borderRadius = "50%";
  p.style.background = "#00ffff";
  p.style.opacity = Math.random() * 0.6 + 0.2;
  p.style.top = Math.random() * 100 + "vh";
  p.style.left = Math.random() * 100 + "vw";
  p.style.animation = `particleFloat ${4 + Math.random() * 6}s linear infinite`;
  field.appendChild(p);
}
