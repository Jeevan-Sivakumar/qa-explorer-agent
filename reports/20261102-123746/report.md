# QA report - 20261102-123746

## Environment and scope

- Target URL: http://localhost:3000/
- Started: 2026-11-02T12:37:46+08:00
- Finished: 2026-11-02T12:46:41+08:00
- Browser: VS Code integrated Playwright-controlled browser
- Viewports: 1440x900 desktop, 390x844 mobile sample
- Conditions: normal network/CPU
- Auth scope: demo guest flow exercised
- Authorized destructive scope used: cancellation of synthetic reservation created during this run

## Health verdict

Partial pass with major usability defects.

Core booking behaviors, promo handling, and cancellation state transitions are functionally present, but multiple primary controls were not operable by mouse due consistent pointer-interception behavior.

## Coverage

| ID | Feature / input / path | Expected | Actual | Outcome | Evidence |
|---|---|---|---|---|---|
| CHECK-001 | Landing page open | Home page loads with main content | Loaded successfully with navigation and stay cards | pass | EV-001 |
| CHECK-002 | Click `Saved stays` (mouse) | Link navigates | Click timed out; header intercepted pointer events | fail | EV-010 |
| CHECK-003 | `Saved stays` via keyboard | Route access or auth gate | Keyboard activation navigated and redirected to login | pass | EV-002 |
| CHECK-004 | Click `Continue as demo guest` (mouse) | Demo session starts | Click timed out; layout intercepted pointer events | fail | EV-002 |
| CHECK-005 | Demo guest via keyboard | Demo session starts | Worked; authenticated state visible | pass | EV-003 |
| CHECK-006 | `With a pool` filter | Pool-only list | List changed from 8 to 4 entries | pass | EV-004 |
| CHECK-007 | `Price: low to high` sort | Ascending numeric price order | Non-ascending order observed | fail | EV-004 |
| CHECK-008 | Open hotel detail | Detail page loads | `#/hotel/the-anda` loaded with pricing form | pass | EV-011 |
| CHECK-009 | Promo `STAY10` | Discount applies | Discount and total recalculated | pass | EV-011 |
| CHECK-010 | Promo `PAST20` | Rejected with clear feedback | Alert with HTTP 422 + reference IDs shown | pass | EV-007, EV-008 |
| CHECK-011 | Click `Continue to reservation` (mouse) | Proceed to checkout | Click timed out; content intercepted pointer events | fail | EV-010 |
| CHECK-012 | Complete booking path | Booking confirmed in list | Redirected to bookings with confirmed reservation | pass | EV-006 |
| CHECK-013 | Click `Cancel reservation` (mouse) | Start cancellation flow | Click timed out; booking panel/image intercepted | fail | EV-010 |
| CHECK-014 | Cancel via keyboard + confirm | Mark booking cancelled | Booking state changed to cancelled with refund text | pass | EV-006 |
| CHECK-015 | Mobile sample (390x844) | Main CTA/navigation usable | Navigation visible; `Find a stay` visible | pass | EV-005 |

Outcome totals:
- pass: 10
- fail: 5
- blocked: 0
- not_tested: 0 in executed set

## Confirmed findings

### QA-001 - Mouse clicks fail on multiple primary controls due pointer interception

- Category: functional-usability
- Severity: high
- Impact: mouse users can be blocked from login, reservation progression, and cancellation
- URL scope: home, login, hotel detail, bookings
- Preconditions: page loaded with target controls visible
- Steps:
  1. Click `Saved stays` in header.
  2. Click `Continue as demo guest` on login.
  3. Click `Continue to reservation` on detail page.
  4. Click `Cancel reservation` in bookings.
- Expected: visible links/buttons activate by mouse click.
- Actual: repeated click timeouts with pointer interception by overlapping containers.
- Working comparison: keyboard focus + Enter succeeded for several of the same actions.
- Reproducibility: 6/6 attempts in sampled contexts.
- Confidence: high.
- Evidence: EV-002, EV-003, EV-006, EV-010.

### QA-002 - `Price: low to high` does not produce ascending order

- Category: functional-data-ordering
- Severity: medium
- Impact: misleading ranking for price-sensitive decisions.
- URL: http://localhost:3000/#/
- Preconditions: discover list visible.
- Steps:
  1. Set sort option to `Price: low to high`.
  2. Compare visible nightly prices from top to bottom.
- Expected: ascending numeric order.
- Actual: top order included RM 890 before RM 680 and RM 780.
- Reproducibility: 1/1 sampled run.
- Confidence: medium-high.
- Evidence: EV-004.

## Suspected issues and risk hypotheses

- Empty-field checkout validation did not show explicit inline error text during this run, although focus behavior suggested native required-field handling.
- Additional checks are needed to confirm whether all required-field and email-format errors are consistently user-visible/accessibility-friendly.

## Performance observations

- No dedicated performance trace captured in this run.
- No SLA claim made.

## Blocked / not tested

- Sort option `Highest rated` not exercised.
- Destination and guest non-default combinations not exercised.
- Payment simulation `Declined payment` not exercised.
- Receipt, policies, and account profile content not exercised.

## Next checks

1. Retest all critical mouse interactions after pointer-hit fix.
2. Validate all sort options against deterministic expected ordering.
3. Exercise declined payment and verify booking is not created.
4. Expand mobile and keyboard checks across checkout and bookings pages.
5. Capture full request/response exports for key validation and booking actions.
