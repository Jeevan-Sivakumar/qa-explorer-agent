# QA report - 20261102-131830

## Environment and scope

- URL: http://localhost:3000
- Started: 2026-11-02T13:18:30+08:00
- Finished: 2026-11-02T13:20:27+08:00
- Browser: VS Code Playwright-controlled browser
- Viewports: 1440x900 desktop, 390x844 mobile sample
- Auth scope: existing signed-in session was present

## Health verdict

Partial with confirmed defects.

## Coverage summary

- Executed checks: 9
- pass: 5
- fail: 4
- blocked: 0
- not_tested in executed set: 0

## Coverage matrix

| ID | Feature / input | Expected | Actual | Outcome | Evidence |
|---|---|---|---|---|---|
| CHECK-001 | Open home | Home loads | Loaded | pass | EV-001 |
| CHECK-002 | Click Saved stays | Navigates | Click timed out | fail | EV-006 |
| CHECK-003 | Keyboard Saved stays | Navigates | Reached `#/saved` | pass | EV-002 |
| CHECK-004 | Sort low-to-high | Ascending order | 890, 680, 1480, 780 | fail | EV-003 |
| CHECK-005 | Click Explore stay | Opens detail | Click timed out | fail | EV-006 |
| CHECK-006 | Keyboard Explore stay | Opens detail | Reached `#/hotel/the-anda` | pass | EV-004 |
| CHECK-007 | Click Continue to reservation | Opens checkout | Click timed out | fail | EV-006 |
| CHECK-008 | Keyboard Continue to reservation | Opens checkout | Reached `#/checkout` | pass | EV-004 |
| CHECK-009 | Mobile sample 390x844 | CTA visible | Find a stay visible | pass | EV-005 |

## Confirmed findings

### QA-001 - Mouse activation fails on primary links and buttons

- Severity: high
- Impact: mouse users can be blocked from key paths.
- Steps: click Saved stays, Explore stay, Continue to reservation.
- Expected: each click activates.
- Actual: click timeout failures.
- Working comparison: keyboard activation succeeds for the same controls.
- Evidence: EV-002, EV-004, EV-006.

### QA-002 - Price low-to-high sort is not ascending

- Severity: medium
- Impact: misleading price ranking.
- Expected: ascending nightly prices.
- Actual: observed top sequence 890, 680, 1480, 780.
- Evidence: EV-003.

## Network and console observations

- Console: no messages observed in sampled interactions.
- Network: no explicit request failure captured in this run.

## Blocked / not tested

- Destination/guest non-default combinations.
- Sort `Highest rated`.
- Declined payment simulation.
- Bookings route content and cancellation in this run.

## Next checks

1. Retest key flows with mouse after pointer-hit fix.
2. Execute all sort and destination combinations.
3. Validate declined payment behavior end to end.
