$ErrorActionPreference = 'Stop'
$runDir = if ($env:QA_REPORT_RUN_DIR) { $env:QA_REPORT_RUN_DIR } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
$repoDir = Split-Path -Parent (Split-Path -Parent $runDir)
$report = Get-Content -Raw (Join-Path $runDir 'report.json') | ConvertFrom-Json
$css = Get-Content -Raw (Join-Path $repoDir 'templates\report.css')
$evidence = @{}
foreach ($item in $report.evidence) {
  $fullPath = Join-Path $runDir $item.path
  if (-not (Test-Path $fullPath)) { throw "Evidence file missing: $fullPath" }
  $bytes = [System.IO.File]::ReadAllBytes($fullPath)
  if ($bytes.Length -eq 0) { throw "Evidence file empty: $fullPath" }
  $evidence[$item.id] = $item
}
function HtmlEscape([object]$value) { [System.Net.WebUtility]::HtmlEncode([string]$value) }
function Badge([string]$value) {
  $className = ($value.ToLowerInvariant() -replace '\s+', '-')
  return '<span class="badge ' + (HtmlEscape $className) + '">' + (HtmlEscape $value) + '</span>'
}
function Img([string]$id) {
  if (-not $evidence.ContainsKey($id)) { return '' }
  $item = $evidence[$id]
  $bytes = [System.IO.File]::ReadAllBytes((Join-Path $runDir $item.path))
  $base64 = [Convert]::ToBase64String($bytes)
  return '<figure class="screenshot"><img alt="' + (HtmlEscape $item.caption) + '" src="data:image/png;base64,' + $base64 + '"><figcaption>' + (HtmlEscape ($item.id + ' - ' + $item.caption)) + '</figcaption></figure>'
}
$counts = @{}
foreach ($status in @('pass','fail','blocked','not_tested')) { $counts[$status] = @($report.coverage | Where-Object outcome -eq $status).Count }
$findingCards = @()
foreach ($finding in $report.findings) {
  $steps = @($finding.steps | ForEach-Object { '<li>' + (HtmlEscape $_) + '</li>' }) -join ''
  $findingImages = @($finding.evidence | ForEach-Object { if ($_ -like 'EVID-*') { Img $_ } }) -join ''
  $findingCards += '<article class="finding" id="' + (HtmlEscape $finding.id) + '"><div class="finding-header"><span class="finding-id">' + (HtmlEscape $finding.id) + '</span>' + (Badge $finding.severity) + (Badge $finding.status) + '</div><h3>' + (HtmlEscape $finding.title) + '</h3><p class="finding-context">' + (HtmlEscape $finding.url) + '</p><dl class="finding-details"><div><dt>Impact</dt><dd>' + (HtmlEscape $finding.impact) + '</dd></div><div><dt>Severity rationale</dt><dd>' + (HtmlEscape $finding.severity_rationale) + '</dd></div><div><dt>Expected</dt><dd>' + (HtmlEscape $finding.expected) + '</dd></div><div><dt>Expected basis</dt><dd>' + (HtmlEscape $finding.expected_basis) + '</dd></div><div><dt>Actual</dt><dd>' + (HtmlEscape $finding.actual) + '</dd></div><div><dt>Comparison / uncertainty</dt><dd>' + (HtmlEscape $finding.comparison) + '</dd></div></dl><h4>Reproduction</h4><ol class="steps">' + $steps + '</ol><p>Attempts: ' + $finding.attempts + '; reproduced: ' + $finding.reproduced + '; confidence: ' + (HtmlEscape $finding.confidence) + '.</p><p><strong>Recommendation:</strong> ' + (HtmlEscape $finding.recommendation) + '</p>' + $findingImages + '</article>'
}
if ($findingCards.Count -eq 0) { $findingHtml = '<p class="empty-state">No defects confirmed within the executed scope.</p>' } else { $findingHtml = $findingCards -join '' }
$coverageRows = @()
foreach ($check in $report.coverage) {
  $refs = @($check.evidence | ForEach-Object { '<span class="tag">' + (HtmlEscape $_) + '</span>' }) -join ' '
  $coverageRows += '<tr><td>' + (HtmlEscape $check.id) + '</td><td>' + (HtmlEscape $check.feature) + '<br><span class="note">' + (HtmlEscape $check.input) + '</span></td><td>' + (HtmlEscape $check.expected) + '<br><span class="note">Basis: ' + (HtmlEscape $check.expected_basis) + '</span></td><td>' + (HtmlEscape $check.actual) + '</td><td>' + (Badge $check.outcome) + '</td><td>' + $refs + '</td></tr>'
}
$inventoryRows = @()
foreach ($item in $report.inventory) { $inventoryRows += '<tr><td>' + (HtmlEscape $item.type) + '</td><td>' + (HtmlEscape $item.name) + '</td><td>' + (HtmlEscape $item.status) + '</td><td>' + (HtmlEscape $item.details) + '</td></tr>' }
$networkRows = @()
foreach ($item in $report.network) { $networkRows += '<tr><td>' + (HtmlEscape $item.trigger) + '</td><td>' + (HtmlEscape ($item.method + ' ' + $item.path)) + '</td><td>' + (HtmlEscape $item.status) + '</td><td>' + (HtmlEscape $item.duration_ms) + '</td><td>' + (HtmlEscape $item.request_id) + '</td></tr>' }
$consoleRows = @()
foreach ($item in $report.console) { $consoleRows += '<tr><td>' + (HtmlEscape $item.trigger) + '</td><td>' + (HtmlEscape $item.type) + '</td><td>' + (HtmlEscape $item.message) + '</td></tr>' }
$gallery = @($report.evidence | Where-Object type -eq 'screenshot' | ForEach-Object { Img $_.id }) -join ''
$limitations = @($report.limitations | ForEach-Object { '<li>' + (HtmlEscape $_) + '</li>' }) -join ''
$nextChecks = @($report.next_checks | ForEach-Object { '<li>' + (HtmlEscape $_) + '</li>' }) -join ''
$networkEvidence = '<li><a href="evidence/network/network-observations.md">Sanitized network observations</a></li>'
$consoleEvidence = '<li><a href="evidence/console/console-observations.md">Sanitized console observations</a></li>'
$summaryPanels = '<div class="summary-grid two-columns"><div class="summary-panel positive"><h3>Verified working</h3><ul><li>Destination filtering worked for Kuala Lumpur, Langkawi, and Cameron Highlands.</li><li>Pool filtering and price/rating ordering matched visible labels.</li><li>Refresh persisted the selected destination, dates, and guest count.</li><li>Valid and invalid promotion/date inputs produced corresponding quote outcomes.</li><li>Mobile Discover and a sampled keyboard-focus check were usable.</li></ul></div><div class="summary-panel negative"><h3>Needs attention</h3><ul><li>Penang filtering failed with HTTP 503 on three attempts.</li><li>The Moss House quote accepted six guests despite a published four-guest maximum.</li></ul></div></div>'
$html = @'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>QA Assessment - {{RUN_ID}}</title>
  <style>{{CSS}}</style>
</head>
<body>
  <aside class="sidebar"><div class="brand">QA <span>Explorer</span></div><p class="sidebar-caption">BROWSER ASSESSMENT</p><nav aria-label="Report sections"><a href="#summary">Summary</a><a href="#coverage">Coverage</a><a href="#findings">Findings</a><a href="#inventory">Inventory</a><a href="#network">Network</a><a href="#accessibility">Accessibility</a><a href="#evidence">Evidence</a><a href="#limits">Limits</a></nav><p class="sidebar-note">Black-box browser assessment. No account credentials or transactions used.</p></aside>
  <main>
    <header class="report-header"><div><p class="eyebrow">QA EXPLORER · BROWSER ASSESSMENT</p><h1>Stays.com</h1><p class="subtitle">Assessment of the visible Discover, detail, and sign-in workflows.</p></div><div class="header-meta">{{ASSESSMENT_BADGE}}<p>Verdict: {{VERDICT}}</p></div></header>
    <div class="target-bar"><div><span>Target</span> <a href="{{URL}}">{{URL}}</a></div><div><span>Run</span> {{RUN_ID}}</div></div>
    <section id="summary"><h2>Executive summary</h2><p class="summary-text">{{VERDICT}}</p><div class="metrics"><a class="metric pass" href="#coverage"><span>Passed checks</span><strong>{{PASS_COUNT}}</strong></a><a class="metric fail" href="#findings"><span>Failed checks</span><strong>{{FAIL_COUNT}}</strong></a><a class="metric warning" href="#limits"><span>Blocked checks</span><strong>{{BLOCKED_COUNT}}</strong></a><a class="metric" href="#limits"><span>Not tested</span><strong>{{NOT_TESTED_COUNT}}</strong></a><a class="metric fail" href="#findings"><span>Unique confirmed defects</span><strong>{{FINDING_COUNT}}</strong></a><a class="metric" href="#evidence"><span>Evidence</span><strong>{{EVIDENCE_STATUS}}</strong></a></div><p>Assessment status: {{ASSESSMENT_STATUS}}. Failed-check count and unique-defect count are separate.</p>{{SUMMARY_PANELS}}</section>
    <section id="coverage"><h2>Coverage</h2><p>All visible destination, guest, pool-filter, and sort options were exercised. Authenticated account flows and the House rules disclosure remain untested or blocked.</p><div class="table-wrap"><table><caption>Executed checks and observed outcomes</caption><thead><tr><th>ID</th><th>Workflow / input</th><th>Expected / basis</th><th>Actual</th><th>Outcome</th><th>Evidence</th></tr></thead><tbody>{{COVERAGE_ROWS}}</tbody></table></div></section>
    <section id="findings"><h2>Confirmed findings</h2>{{FINDINGS}}</section>
    <section id="inventory"><h2>Application inventory</h2><div class="table-wrap"><table><caption>Discovered pages, controls, and records</caption><thead><tr><th>Type</th><th>Name</th><th>Coverage</th><th>Details</th></tr></thead><tbody>{{INVENTORY_ROWS}}</tbody></table></div></section>
    <section id="network"><h2>Network and console</h2><p>Durations were unavailable. No sensitive request data is included.</p><div class="table-wrap"><table><caption>Observed requests</caption><thead><tr><th>Trigger</th><th>Method / endpoint</th><th>Status</th><th>Duration ms</th><th>Request ID</th></tr></thead><tbody>{{NETWORK_ROWS}}</tbody></table></div><h3 class="subheading">Console observations</h3><div class="table-wrap"><table><thead><tr><th>Trigger</th><th>Type</th><th>Observation</th></tr></thead><tbody>{{CONSOLE_ROWS}}</tbody></table></div><ul>{{NETWORK_EVIDENCE}}{{CONSOLE_EVIDENCE}}</ul></section>
    <section id="performance"><h2>Performance</h2><p class="empty-state">Not measured. Available browser request listings did not expose durations; no latency samples or performance trace were collected.</p></section>
    <section id="accessibility"><h2>Accessibility observations</h2><ul><li>First Tab reached Skip to content with a visible outline.</li><li>At 390 x 844, the primary Discover action was visible and the document did not overflow horizontally.</li><li>Coverage is sampled only. No WCAG conformance claim is made.</li></ul></section>
    <section id="evidence"><h2>Screenshot gallery</h2><div class="gallery">{{GALLERY}}</div><p class="note">Images are embedded from verified browser screenshot files; this HTML is self-contained.</p></section>
    <section id="limits"><h2>Limitations and next checks</h2><h3>Limitations</h3><ul>{{LIMITATIONS}}</ul><h3 class="subheading">Prioritized next checks</h3><ol>{{NEXT_CHECKS}}</ol></section>
    <section id="environment"><h2>Environment and supporting artifacts</h2><p>{{ENVIRONMENT}}</p><dl class="run-details"><div><dt>Run ID</dt><dd>{{RUN_ID}}</dd></div><div><dt>Started</dt><dd>{{STARTED_AT}}</dd></div><div><dt>Finished</dt><dd>{{FINISHED_AT}}</dd></div><div><dt>Browser</dt><dd>Chrome DevTools MCP</dd></div><div><dt>Viewports</dt><dd>1440 x 900; 390 x 844</dd></div><div><dt>Network / CPU</dt><dd>Normal; no throttling</dd></div><div><dt>Authentication scope</dt><dd>Anonymous; test account unavailable</dd></div><div><dt>Execution limits</dt><dd>Public browser flows only; no transaction</dd></div></dl><h3 class="subheading">Supporting artifacts</h3><ul><li><a href="report.json">Structured report (source of truth)</a></li><li><a href="report.md">Markdown report</a></li><li><a href="application-inventory.md">Application inventory</a></li><li><a href="execution-log.md">Execution log</a></li></ul></section>
    <footer>QA Explorer · Evidence-based assessment · {{RUN_ID}}</footer>
  </main>
</body>
</html>
'@
$tokens = @{
  '{{CSS}}' = $css
  '{{RUN_ID}}' = (HtmlEscape $report.run_id)
  '{{ASSESSMENT_BADGE}}' = (Badge $report.assessment_status)
  '{{VERDICT}}' = (HtmlEscape $report.verdict)
  '{{URL}}' = (HtmlEscape $report.url)
  '{{PASS_COUNT}}' = [string]$counts.pass
  '{{FAIL_COUNT}}' = [string]$counts.fail
  '{{BLOCKED_COUNT}}' = [string]$counts.blocked
  '{{NOT_TESTED_COUNT}}' = [string]$counts.not_tested
  '{{FINDING_COUNT}}' = [string]$report.findings.Count
  '{{EVIDENCE_STATUS}}' = (HtmlEscape $report.evidence_status)
  '{{ASSESSMENT_STATUS}}' = (HtmlEscape $report.assessment_status)
  '{{SUMMARY_PANELS}}' = $summaryPanels
  '{{COVERAGE_ROWS}}' = ($coverageRows -join '')
  '{{FINDINGS}}' = $findingHtml
  '{{INVENTORY_ROWS}}' = ($inventoryRows -join '')
  '{{NETWORK_ROWS}}' = ($networkRows -join '')
  '{{CONSOLE_ROWS}}' = ($consoleRows -join '')
  '{{NETWORK_EVIDENCE}}' = $networkEvidence
  '{{CONSOLE_EVIDENCE}}' = $consoleEvidence
  '{{GALLERY}}' = $gallery
  '{{LIMITATIONS}}' = $limitations
  '{{NEXT_CHECKS}}' = $nextChecks
  '{{ENVIRONMENT}}' = (HtmlEscape $report.environment)
  '{{STARTED_AT}}' = (HtmlEscape $report.started_at)
  '{{FINISHED_AT}}' = (HtmlEscape $report.finished_at)
}
foreach ($key in $tokens.Keys) { $html = $html.Replace($key, [string]$tokens[$key]) }
if ($html -match '\{\{[A-Z_]+\}\}') { throw 'Unresolved report placeholder remains.' }
$outPath = Join-Path $runDir 'report.html'
[System.IO.File]::WriteAllText($outPath, $html, [System.Text.UTF8Encoding]::new($false))
Write-Output "Generated $outPath"
