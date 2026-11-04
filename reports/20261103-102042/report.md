# QA report - 20261103-102042

- URL: http://localhost:3000
- Started: 2026-11-03T10:20:42+08:00
- Finished: 2026-11-03T10:23:36+08:00
- Assessment status: partial
- Verdict: Partial assessment with 3 confirmed defects in destination filtering, account preferences, and listing asset delivery.

## Confirmed findings

1. QA-001 (high, P1): Penang destination filter returns HTTP 503 and blocks destination results.
2. QA-002 (high, P1): Account Travel preferences returns HTTP 500 on load and retry.
3. QA-003 (medium, P2): Rimba Terrace card image asset `/assets/missing-rimba.svg` returns HTTP 500.

## Coverage snapshot

- Checks executed: 8
- pass: 4
- fail: 4
- blocked: 0
- not_tested: 0

## Evidence index

- Screenshots:
  - SHOT-001-overview-desktop.png
  - SHOT-002-penang-filter.png
  - SHOT-003-account-preferences-500.png
  - SHOT-004-home-broken-rimba-image.png
  - SHOT-005-home-mobile-390x844.png
- Network evidence: `evidence/network/network-observations.md`
- Console evidence: `evidence/console/console-observations.md`

## Limitations

- This was a short exploratory pass and not an exhaustive combinational sweep.
- No synthetic reservation create/cancel flow was executed in this run.
- Request/response payload bodies were not exported in this tool pass.
