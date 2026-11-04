"""Render recorded observations only; standard-library Python, no browser or API calls."""
import argparse
import html
import json
from pathlib import Path
from urllib.parse import urlsplit


def esc(value):
    return html.escape(str(value if value is not None else 'Not recorded'), quote=True)


def evidence_link(value):
    if not isinstance(value, str):
        return esc(value)
    path = Path(value)
    parsed = urlsplit(value)
    # Only relative evidence references. No javascript/file/remote URLs.
    if parsed.scheme or parsed.netloc or path.is_absolute() or '..' in path.parts or '\\' in value or ':' in value:
        return esc(value)
    return f'<a href="{esc(value)}">{esc(value)}</a>'


def render(data):
    coverage = data.get('coverage', [])
    findings = data.get('findings', [])
    if not isinstance(coverage, list) or not isinstance(findings, list):
        raise ValueError('coverage and findings must be arrays')
    counts = {key: sum(c.get('outcome') == key for c in coverage) for key in ('pass','fail','blocked','not_tested')}
    rows = ''.join('<tr>' + ''.join(f'<td>{esc(c.get(k))}</td>' for k in ('id','feature','input','expected','actual','outcome')) + '<td>' + ', '.join(evidence_link(x) for x in c.get('evidence', [])) + '</td></tr>' for c in coverage)
    cards = []
    for f in findings:
        fields = ''.join(f'<dt>{esc(k.replace("_", " ").title())}</dt><dd>{esc(f.get(k))}</dd>' for k in ('category','severity','impact','url','expected','expected_basis','actual','comparison','attempts','reproduced','confidence'))
        pre = ''.join(f'<li>{esc(x)}</li>' for x in f.get('preconditions', []))
        steps = ''.join(f'<li>{esc(x)}</li>' for x in f.get('steps', []))
        evidence = ''.join(f'<li>{evidence_link(x)}</li>' for x in f.get('evidence', []))
        jira = f.get('jira_url')
        parsed = urlsplit(jira) if isinstance(jira,str) else None
        action = f'<a class="ticket" href="{esc(jira)}" rel="noopener noreferrer">Open Jira ticket ↗</a>' if parsed and parsed.scheme == 'https' and parsed.hostname and not parsed.username else '<p class="muted">Jira ticket not created. Review findings before authorizing publication through Atlassian MCP.</p>'
        cards.append(f'<article><p class="tag">{esc(f.get("status"))}</p><h2>{esc(f.get("id"))} · {esc(f.get("title"))}</h2><h3>Preconditions</h3><ul>{pre}</ul><h3>Steps</h3><ol>{steps}</ol><dl>{fields}</dl><h3>Network observations</h3><pre>{esc(json.dumps(f.get("network",[]),indent=2))}</pre><h3>Evidence</h3><ul>{evidence}</ul>{action}</article>')
    limitations = ''.join(f'<li>{esc(x)}</li>' for x in data.get('limitations', []))
    next_checks = ''.join(f'<li>{esc(x)}</li>' for x in data.get('next_checks', []))
    totals = ' · '.join(f'{k}: {v}' for k,v in counts.items())
    return f'''<!doctype html><html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>QA report — {esc(data.get('run_id'))}</title><style>body{{font:15px/1.6 system-ui,sans-serif;color:#203c36;background:#f5f6f2;margin:0;padding:35px;max-width:1250px;margin-inline:auto}}article,section{{background:white;border:1px solid #dce2d8;border-radius:8px;padding:25px;margin:20px 0}}h1{{font-size:36px}}h2{{font-size:24px}}.muted{{color:#5a6a63}}.tag{{text-transform:uppercase;letter-spacing:1px;font-size:12px}}table{{border-collapse:collapse;width:100%;font-size:13px}}th,td{{border:1px solid #dce2d8;padding:10px;text-align:left;vertical-align:top}}.table{{overflow:auto}}dt{{font-weight:600}}dd{{margin:0 0 12px;white-space:pre-wrap;overflow-wrap:anywhere}}a{{color:#175b4d}}pre{{white-space:pre-wrap;overflow-wrap:anywhere}}.ticket{{display:inline-block;padding:9px 14px;background:#e4eee7;border-radius:4px}}@media(max-width:600px){{body{{padding:15px}}}}</style><header><p class="tag">QA Explorer · Observed results</p><h1>{esc(data.get('run_id'))}</h1><p>{esc(data.get('url'))}</p><p class="muted">{esc(data.get('started_at'))} → {esc(data.get('finished_at'))}</p></header><section><h2>Health verdict</h2><p>{esc(data.get('verdict'))}</p><p>{esc(data.get('environment'))}</p></section><section><h2>Coverage</h2><p>{len(coverage)} listed checks · {totals}</p><p class="muted">Counts describe the listed checks, not exhaustive application coverage.</p><div class="table"><table><thead><tr><th>ID</th><th>Feature</th><th>Input</th><th>Expected</th><th>Actual</th><th>Outcome</th><th>Evidence</th></tr></thead><tbody>{rows}</tbody></table></div></section>{''.join(cards)}<section><h2>Limitations</h2><ul>{limitations}</ul><h2>Next checks</h2><ul>{next_checks}</ul></section></html>'''


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('input', type=Path)
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    output = args.output or args.input.with_suffix('.html')
    if output.resolve() == args.input.resolve():
        parser.error('Output must differ from the input JSON')
    data = json.loads(args.input.read_text(encoding='utf-8-sig'))
    if not isinstance(data, dict):
        parser.error('Input must be a report object')
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(render(data), encoding='utf-8')
    print(output)


if __name__ == '__main__':
    main()
