const fs = require('fs');
const path = require('path');

const runDir = path.resolve(__dirname, '..', '..');
const reportPath = path.join(runDir, 'report.json');
const outPath = path.join(runDir, 'report.html');
const report = JSON.parse(fs.readFileSync(reportPath, 'utf8'));

const esc = (v) =>
  String(v ?? '').replace(/[&<>"']/g, (c) => ({
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#39;'
  }[c]));

const list = (arr) => {
  const items = Array.isArray(arr) ? arr : [];
  if (!items.length) return '<span class="muted">Not provided</span>';
  return `<ul>${items.map((x) => `<li>${esc(x)}</li>`).join('')}</ul>`;
};

const checks = Array.isArray(report.coverage) ? report.coverage : [];
const findings = Array.isArray(report.findings) ? report.findings : [];
const evidence = Array.isArray(report.evidence) ? report.evidence : [];

const normalizeOutcome = (v) => {
  const raw = String(v || '').toLowerCase();
  if (raw.includes('pass')) return 'pass';
  if (raw.includes('fail')) return 'fail';
  if (raw.includes('block')) return 'blocked';
  return 'not_tested';
};

const counts = { pass: 0, fail: 0, blocked: 0, not_tested: 0 };
checks.forEach((c) => {
  counts[normalizeOutcome(c.outcome)] += 1;
});

const evidenceById = new Map(evidence.map((e) => [e.id, e]));
const screenshotDataUriById = new Map();

for (const e of evidence) {
  if (e.type !== 'screenshot' || !e.path) continue;
  const abs = path.join(runDir, e.path);
  if (!fs.existsSync(abs)) continue;
  const ext = path.extname(abs).toLowerCase();
  const mime = ext === '.jpg' || ext === '.jpeg' ? 'image/jpeg' : ext === '.webp' ? 'image/webp' : 'image/png';
  const b64 = fs.readFileSync(abs).toString('base64');
  screenshotDataUriById.set(e.id, `data:${mime};base64,${b64}`);
}

const metricCard = (label, value, href = null) => {
  const inner = `<b>${esc(value)}</b><span>${esc(label)}</span>`;
  if (!href) return `<div class="metric card">${inner}</div>`;
  return `<a class="metric card" href="${href}">${inner}</a>`;
};

const evidenceLinks = (ids) => {
  const arr = Array.isArray(ids) ? ids : [];
  if (!arr.length) return '<span class="muted">None</span>';
  return arr
    .map((id) => {
      const ev = evidenceById.get(id);
      if (!ev) return `<span class="muted">${esc(id)}</span>`;
      if (ev.type === 'screenshot' && screenshotDataUriById.has(id)) {
        return `<a href="#evid-${esc(id)}" class="ev-link">${esc(id)}</a>`;
      }
      return `<a href="${esc(ev.path)}">${esc(id)}</a>`;
    })
    .join(' ');
};

const findingCards = findings.length
  ? findings
      .map((f) => {
        const steps = list(f.steps || []);
        const possibleCauses = list(f.possible_causes || []);
        return `
        <article class="card finding" id="${esc(f.id)}">
          <div class="finding-head">
            <h3>${esc(f.id)} - ${esc(f.title)}</h3>
            <span class="pill sev">${esc(f.severity || 'unspecified')}</span>
            <span class="pill pri">${esc(f.priority || 'unspecified')}</span>
          </div>
          <p><strong>Category:</strong> ${esc(f.category || 'N/A')}</p>
          <p><strong>Severity rationale:</strong> ${esc(f.severity_rationale || 'N/A')}</p>
          <p><strong>Priority rationale:</strong> ${esc(f.priority_rationale || 'N/A')}</p>
          <p><strong>Impact:</strong> ${esc(f.impact || 'N/A')}</p>
          <div class="cols">
            <div><h4>Expected</h4><p>${esc(f.expected || '')}</p><p class="muted">${esc(f.expected_basis || '')}</p></div>
            <div><h4>Actual</h4><p>${esc(f.actual || '')}</p><p class="muted">${esc(f.comparison || '')}</p></div>
          </div>
          <h4>Steps</h4>
          ${steps}
          <p><strong>Attempts:</strong> ${esc(f.attempts ?? 'N/A')} | <strong>Reproduced:</strong> ${esc(f.reproduced ?? 'N/A')}</p>
          <p><strong>Evidence:</strong> ${evidenceLinks(f.evidence)}</p>
          <details>
            <summary>Hypothesis / details</summary>
            <p><strong>Possible causes</strong></p>
            ${possibleCauses}
            <p><strong>Recommendation:</strong> ${esc(f.recommendation || 'N/A')}</p>
          </details>
        </article>`;
      })
      .join('')
  : '<div class="card">No confirmed findings.</div>';

const checkRows = checks
  .map((c) => {
    const out = normalizeOutcome(c.outcome);
    return `
      <tr id="${esc(c.id)}">
        <td>${esc(c.id)}</td>
        <td>${esc(c.feature || '')}</td>
        <td>${esc(c.input || '')}</td>
        <td>${esc(c.expected || '')}</td>
        <td>${esc(c.actual || '')}</td>
        <td><span class="badge ${out}">${esc(out)}</span></td>
        <td>${evidenceLinks(c.evidence)}</td>
      </tr>`;
  })
  .join('');

const screenshotGallery = evidence
  .filter((e) => e.type === 'screenshot' && screenshotDataUriById.has(e.id))
  .map(
    (e) => `
      <figure class="shot" id="evid-${esc(e.id)}">
        <img src="${screenshotDataUriById.get(e.id)}" alt="${esc(e.caption || e.id)}" data-evid="${esc(e.id)}" class="shot-open"/>
        <figcaption><strong>${esc(e.id)}</strong> ${esc(e.caption || '')}</figcaption>
      </figure>`
  )
  .join('');

const html = `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>QA Explorer Report</title>
  <style>
    :root {
      --bg:#f3f5f9;--card:#fff;--navy:#101d32;--blue:#225cce;--text:#202d40;--muted:#5d6b7e;--border:#dce3ec;
      --pass:#1f8f49;--fail:#c63a30;--blocked:#9a6a11;
    }
    *{box-sizing:border-box}
    body{margin:0;background:var(--bg);color:var(--text);font:14px/1.5 "Segoe UI",system-ui,sans-serif}
    a{color:var(--blue);text-decoration:none}
    .layout{display:flex;min-height:100vh}
    .side{width:238px;background:var(--navy);color:#e5eefc;padding:22px 16px;position:sticky;top:0;height:100vh}
    .side h2{margin:0 0 14px;font-size:20px;color:#fff}
    .side a{display:block;color:#cbdaf7;padding:7px 0}
    .main{flex:1;padding:24px}
    .card{background:var(--card);border:1px solid var(--border);border-radius:12px;padding:14px}
    .metrics{display:grid;grid-template-columns:repeat(6,minmax(130px,1fr));gap:10px}
    .metric{display:block}
    .metric b{display:block;color:var(--navy);font-size:26px}
    .metric span{color:var(--muted)}
    .panels{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-top:10px}
    .section{margin-top:18px}
    .finding{margin-bottom:12px}
    .finding-head{display:flex;gap:8px;align-items:center;flex-wrap:wrap}
    .finding-head h3{margin:0;flex:1;color:var(--navy)}
    .pill{padding:3px 10px;border-radius:999px;font-size:12px;font-weight:600}
    .sev{background:#ffe9e8;color:#9f241d}.pri{background:#e8efff;color:#1f4ab4}
    .cols{display:grid;grid-template-columns:1fr 1fr;gap:10px}
    table{width:100%;border-collapse:collapse;background:var(--card);border:1px solid var(--border);border-radius:12px;overflow:hidden}
    th,td{border-bottom:1px solid var(--border);padding:9px;vertical-align:top;text-align:left}
    th{background:#f8faff;color:var(--navy)}
    .badge{padding:3px 8px;border-radius:999px;font-size:12px;font-weight:700}
    .pass{background:#e5f5eb;color:var(--pass)}.fail{background:#fdeaea;color:var(--fail)}.blocked{background:#fff2dc;color:var(--blocked)}.not_tested{background:#eef2f7;color:#53627a}
    .muted{color:var(--muted)}
    .ev-link{margin-right:8px}
    ul{margin:8px 0 8px 20px}
    .shots{display:grid;grid-template-columns:repeat(2,minmax(280px,1fr));gap:12px}
    .shot img{max-width:100%;height:260px;object-fit:contain;background:#fff;border:1px solid var(--border);border-radius:8px;cursor:zoom-in}
    .modal{position:fixed;inset:0;background:rgba(16,29,50,.85);display:none;align-items:center;justify-content:center;padding:20px}
    .modal.open{display:flex}
    .modal-box{background:#fff;max-width:95vw;max-height:95vh;width:1100px;border-radius:12px;padding:10px;display:flex;flex-direction:column;gap:8px}
    .modal-tools{display:flex;gap:8px}
    .modal-body{overflow:auto;border:1px solid var(--border);border-radius:8px;background:#f8fbff}
    .modal-body img{display:block;max-width:100%;height:auto;margin:0 auto;object-fit:contain}
    .orig .modal-body img{max-width:none}
    @media (max-width: 980px){
      .layout{display:block}
      .side{position:static;width:100%;height:auto}
      .metrics{grid-template-columns:repeat(2,minmax(140px,1fr))}
      .panels,.cols,.shots{grid-template-columns:1fr}
      .main{padding:14px}
      table{display:block;overflow:auto}
    }
    @media print{
      .side,.modal{display:none !important}
      .main{padding:0}
      .card,table{break-inside:avoid}
      .shot img{height:auto;max-height:320px}
    }
  </style>
</head>
<body>
  <div class="layout">
    <aside class="side">
      <h2>QA Explorer</h2>
      <a href="#summary">Summary</a>
      <a href="#findings">Findings</a>
      <a href="#checks">Checks</a>
      <a href="#evidence">Evidence</a>
      <a href="#inventory">Inventory</a>
      <a href="#limitations">Limitations</a>
      <a href="#next">Next checks</a>
      <a href="#environment">Environment</a>
    </aside>
    <main class="main">
      <section id="summary" class="section card">
        <h1>${esc('Stays.com sampled QA assessment')}</h1>
        <p><strong>Run ID:</strong> ${esc(report.run_id)} | <strong>Mode:</strong> ${esc(report.mode)} | <strong>Duration:</strong> ${esc(report.elapsed_seconds)}s</p>
        <p><strong>URL:</strong> ${esc(report.url)}</p>
        <p><strong>Assessment:</strong> partial sampled assessment | <strong>Verdict:</strong> ${esc(report.verdict || '')}</p>
        <div class="metrics">
          ${metricCard('Passed checks', counts.pass, '#checks-pass')}
          ${metricCard('Failed checks', counts.fail, '#checks-fail')}
          ${metricCard('Blocked checks', counts.blocked)}
          ${metricCard('Not tested', counts.not_tested)}
          ${metricCard('Unique defects', findings.length, '#findings')}
          ${metricCard('Evidence status', report.evidence_status || 'partial')}
        </div>
        <div class="panels">
          <div class="card"><strong>Verified working</strong><p class="muted">Authenticated homepage rendering and primary title-link routing for The Anda were verified.</p></div>
          <div class="card"><strong>Needs attention</strong><p class="muted">Pool filter semantics and first-card secondary CTA routing both mislead discovery outcomes.</p></div>
        </div>
      </section>

      <section id="findings" class="section">
        <h2>Confirmed defects</h2>
        ${findingCards}
      </section>

      <section id="checks" class="section">
        <h2>Checks and outcomes</h2>
        <div id="checks-pass"></div>
        <div id="checks-fail"></div>
        <table>
          <thead>
            <tr>
              <th>ID</th><th>Scenario</th><th>Input</th><th>Expected</th><th>Actual</th><th>Outcome</th><th>Evidence</th>
            </tr>
          </thead>
          <tbody>${checkRows}</tbody>
        </table>
      </section>

      <section id="evidence" class="section card">
        <h2>Screenshots</h2>
        <div class="shots">${screenshotGallery || '<p class="muted">No screenshot evidence embedded.</p>'}</div>
      </section>

      <section id="inventory" class="section card"><h2>Inventory</h2>${list(report.inventory)}</section>
      <section id="limitations" class="section card"><h2>Limitations</h2>${list(report.limitations)}</section>
      <section id="next" class="section card"><h2>Next checks</h2>${list(report.next_checks)}</section>
      <section id="environment" class="section card">
        <h2>Environment</h2>
        <p><strong>Started:</strong> ${esc(report.started_at)} | <strong>Finished:</strong> ${esc(report.finished_at)}</p>
        <p><strong>Environment:</strong> ${esc(report.environment || '')}</p>
        <p><strong>Access:</strong> ${esc(report.access || '')}</p>
        <p><a href="report.json">View report.json</a></p>
      </section>
    </main>
  </div>

  <div id="imgModal" class="modal" aria-hidden="true">
    <div class="modal-box" id="imgModalBox">
      <div class="modal-tools">
        <button id="fitBtn" type="button">Fit view</button>
        <button id="origBtn" type="button">Original size</button>
        <button id="closeBtn" type="button">Close</button>
      </div>
      <div class="modal-body"><img id="modalImg" alt="Evidence" /></div>
    </div>
  </div>

  <script>
    const modal = document.getElementById('imgModal');
    const modalBox = document.getElementById('imgModalBox');
    const modalImg = document.getElementById('modalImg');
    const closeBtn = document.getElementById('closeBtn');
    const fitBtn = document.getElementById('fitBtn');
    const origBtn = document.getElementById('origBtn');

    function openImage(src, alt) {
      modalImg.src = src;
      modalImg.alt = alt || 'Evidence image';
      modal.classList.add('open');
      modalBox.classList.remove('orig');
      modal.setAttribute('aria-hidden', 'false');
    }

    function closeImage() {
      modal.classList.remove('open');
      modal.setAttribute('aria-hidden', 'true');
      modalImg.src = '';
    }

    document.querySelectorAll('.shot-open').forEach((img) => {
      img.addEventListener('click', () => openImage(img.src, img.alt));
    });

    closeBtn.addEventListener('click', closeImage);
    fitBtn.addEventListener('click', () => modalBox.classList.remove('orig'));
    origBtn.addEventListener('click', () => modalBox.classList.add('orig'));

    modal.addEventListener('click', (e) => {
      if (e.target === modal) closeImage();
    });

    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape') closeImage();
    });
  </script>
</body>
</html>`;

fs.writeFileSync(outPath, html, 'utf8');
console.log(`REPORT_HTML=${outPath}`);
console.log(`EMBEDDED_SCREENSHOTS=${screenshotDataUriById.size}`);
