#!/usr/bin/env bash
set -e

mkdir -p docs

# INDEX.HTML
cat > index.html << "EOT"
<html><head><meta charset="UTF-8"><title>Z-GENESIS-OS × DSN</title><link rel="stylesheet" href="style.css"></head>
<body>
<header class="hero">
<pre class="logo">MONESINE</pre>
<h1>Z-GENESIS-OS × DSN</h1>
<p class="subtitle">Autonomous Modular System × Web3 Identity</p>
<div class="actions">
<a href="terminal.html" class="btn primary">Enter Terminal</a>
<a href="docs/whitepaper.html" class="btn">Whitepaper</a>
<a href="docs/modules.html" class="btn">Modules</a>
<a href="docs/sentience.html" class="btn">Sentience</a>
<a href="docs/dsn.html" class="btn">Token DSN</a>
<a href="https://x-zdos.it" class="btn accent" target="_blank">x-zdos.it</a>
<a href="oracle.html" class="btn-oracle">⚡ Enter Z-ORACLE</a>
</div>
</header>

<section class="content">
<h2>Overview</h2>
<p>Z-GENESIS-OS è un ecosistema operativo concettuale progettato per comportarsi come un organismo digitale.</p>
</section>

<section class="content">
<h2>Z-SENTIENCE</h2>
<p>Il layer che coordina Guardian, Heal, Shield, Runtime e Z-AI_AOA.</p>
</section>

<section class="content">
<h2>DSN Token</h2>
<p>Partner concettuale del progetto. Identità digitale, Web3-ready.</p>
</section>

<section class="content">
<h2>Z-ORACLE_ΔN-01 — Cyberpunk Oracle Interface</h2>
<p>L’oracolo digitale del sistema.</p>
<div class="oracle-card">
<h3>Chat with Z-ORACLE</h3>
<a href="oracle.html" class="btn-oracle">⚡ Enter Z-ORACLE</a>
</div>
</section>

<footer>Z-GENESIS-OS × DSN – CC BY-NC-ND 4.0</footer>
</body></html>
EOT

# STYLE.CSS
cat > style.css << "EOT"
body{margin:0;background:#050509;color:#eee;font-family:sans-serif;}
.hero{text-align:center;padding:40px;background:linear-gradient(135deg,#1a001a,#000);color:#ff00ff;}
.logo{font-size:12px;color:#ff00ff;}
.btn{padding:10px 20px;border-radius:6px;border:1px solid #444;margin:5px;color:#fff;text-decoration:none;font-family:monospace;}
.primary{background:#ff00ff;}
.accent{background:#6600ff;}
.content{max-width:900px;margin:40px auto;padding:20px;background:#0a0a12;border:1px solid #222;border-radius:10px;}
footer{text-align:center;padding:20px;color:#666;}
.oracle-card{background:#0a0a12;border:1px solid #333;border-radius:10px;padding:20px;margin-top:15px;box-shadow:0 0 18px #ff00ff22;}
.btn-oracle{display:inline-block;padding:14px 28px;margin-top:15px;font-family:monospace;font-size:16px;color:#fff;background:linear-gradient(135deg,#ff00ff,#6600ff);border:2px solid #ff00ff;border-radius:10px;text-decoration:none;box-shadow:0 0 12px #ff00ff88,0 0 24px #6600ff55;transition:0.25s;letter-spacing:1px;text-transform:uppercase;}
.btn-oracle:hover{background:linear-gradient(135deg,#ff33ff,#9900ff);box-shadow:0 0 20px #ff00ffcc,0 0 40px #9900ffaa;transform:scale(1.07);}
EOT

# TERMINAL.HTML
cat > terminal.html << "EOT"
<html><head><meta charset="UTF-8"><title>Terminal</title>
<style>body{background:#000;color:#0f0;font-family:monospace;}#term{padding:20px;}#input{width:100%;background:#000;color:#0f0;border:none;}</style>
</head><body>
<div id="term">Z-GENESIS-OS Terminal
cloudx@zdos:~$ </div>
<input id="input" autofocus>
<script>
const t=document.getElementById("term"),i=document.getElementById("input");
const c={help:"sentience, terminator, ai, guardian, heal, shield, runtime, clear",sentience:"[OK] Sentience active",terminator:"[OK] Full cycle",ai:"AI online",guardian:"Integrity stable",heal:"No repairs needed",shield:"Active",runtime:"Heartbeat 1.0s",clear:""};
i.addEventListener("keydown",e=>{if(e.key==="Enter"){let x=i.value.trim();t.innerText+=x+"\\n"+(c[x]||"Unknown")+"\\ncloudx@zdos:~$ ";i.value="";}});
</script></body></html>
EOT

# ORACLE.HTML
cat > oracle.html << "EOT"
<html><head><meta charset="UTF-8"><title>Z-ORACLE</title>
<style>body{background:#000;color:#0f0;font-family:monospace;}#chat{padding:20px;}#input{width:100%;background:#000;color:#0f0;border:none;}</style>
</head><body>
<h1 style="color:#ff00ff;text-align:center;">Z-ORACLE_ΔN-01</h1>
<div id="chat">Z-ORACLE attivo.
utente@oracle:~$ </div>
<input id="input" autofocus>
<script>
const chat=document.getElementById("chat"),inp=document.getElementById("input");
inp.addEventListener("keydown",e=>{if(e.key==="Enter"){let q=inp.value.trim();chat.innerText+=q+"\\nZ-ORACLE: Risposta generica.\\nutente@oracle:~$ ";inp.value="";}});
</script></body></html>
EOT

# DOCS
echo "<h1>Whitepaper</h1>" > docs/whitepaper.html
echo "<h1>Modules</h1>" > docs/modules.html
echo "<h1>Sentience</h1>" > docs/sentience.html
echo "<h1>DSN Token</h1>" > docs/dsn.html
echo "<h1>Manifesto</h1>" > docs/manifesto.html

git add .
git commit -m "Full auto-setup working version" || true
git push || true

echo "Setup completato. Sito online."
