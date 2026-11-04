# QA report - 20261102-134212

- URL: http://localhost:3000
- Started: 2026-11-02T13:42:12+08:00
- Finished: 2026-11-02T13:52:04+08:00
- Assessment status: partial
- Verdict: Partial assessment with 2 confirmed backend defects and multiple verified passing flows.

## Key findings

1. QA-001 (high): Destination filter `Penang` fails with HTTP 503 and blocks destination browsing.
2. QA-002 (high): Account `Travel preferences` fails with HTTP 500 on load and retry.

## Coverage snapshot

- Checks executed: 14
- pass: 10
- fail: 3
- blocked: 2
- not_tested: 0

## Primary evidence

- Screenshots: `evidence/screenshots/SHOT-001` to `SHOT-008`
- Network summary: `evidence/network/network-observations.md`
- Console summary: `evidence/console/console-observations.md`

## Important limitations

- Mobile detail sample at 390x844 was blocked by browser window-state resize restriction.
- Synthetic booking/cancellation flow not executed pending explicit transaction authorization.
