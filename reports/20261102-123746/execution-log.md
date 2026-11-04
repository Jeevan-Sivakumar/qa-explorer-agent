# Execution log

| Entry ID | Time (local) | Page/workflow | Action/tool | Observed result | Evidence |
|---|---|---|---|---|---|
| LOG-001 | 12:37:46 | Preflight | Workspace checks | Run directory and evidence folders created; templates present | `reports/20261102-123746/` |
| LOG-002 | 12:38:27 | Home | Playwright screenshot | Desktop overview screenshot persisted and non-empty | `evidence/screenshots/SHOT-001-overview-desktop.png` |
| LOG-003 | 12:39 | Home nav | Click `Saved stays` | Mouse click timed out; header intercepted pointer events | Tool log + later comparison |
| LOG-004 | 12:39 | Home nav | Keyboard `Enter` on `Saved stays` link | Navigation succeeded; auth redirected to `#/login` | State snapshots |
| LOG-005 | 12:40 | Login | Click `Continue as demo guest` | Mouse click timed out; layout intercepted pointer events | `evidence/screenshots/SHOT-002-login-page.png` |
| LOG-006 | 12:40 | Login | Keyboard `Enter` on demo button | Demo session activated; reached saved page | State snapshot |
| LOG-007 | 12:40 | Saved page | Click `Discover your next stay` | Mouse click timed out; content elements intercepted pointer events | `evidence/screenshots/SHOT-003-saved-empty.png` |
| LOG-008 | 12:41 | Discover | Filter and sort exercise | `With a pool` reduced cards 8->4; `Price: low to high` ordering incorrect | `evidence/screenshots/SHOT-004-pool-filter-sort-asc.png` |
| LOG-009 | 12:41 | Hotel detail | Keyboard navigate to hotel | Reached `#/hotel/the-anda` successfully | State snapshot |
| LOG-010 | 12:41 | Pricing | Enter `STAY10` promo | Discount and totals recalculated (`-RM 267.00`) | State snapshot |
| LOG-011 | 12:41 | Pricing | Enter `PAST20` promo | Alert shown: invalid/expired; reference shown; console logged HTTP 422 resource error | `evidence/console/console-observations.md`, `evidence/network/network-observations.md` |
| LOG-012 | 12:42 | Reservation CTA | Click `Continue to reservation` | Mouse click timed out; page content intercepted pointer events | Tool log |
| LOG-013 | 12:42 | Reservation CTA | Keyboard `Enter` after clearing promo | Navigation to checkout succeeded | State snapshot |
| LOG-014 | 12:42 | Checkout | Submit with empty fields | Focus remained in required field; no explicit inline message observed | State snapshot |
| LOG-015 | 12:42 | Checkout | Submit with valid synthetic details | Booking confirmed; redirected to `#/bookings` | State snapshot |
| LOG-016 | 12:43 | Bookings | Click `Cancel reservation` | Mouse click timed out; booking card image/panel intercepted pointer events | Tool log |
| LOG-017 | 12:43 | Bookings | Keyboard `Enter` + confirm dialog accept | Booking moved to cancelled state; refund line displayed | `evidence/screenshots/SHOT-006-bookings-cancelled.png` |
| LOG-018 | 12:44 | Mobile sample | 390x844 responsive check | Primary nav and `Find a stay` CTA visible/reachable | `evidence/screenshots/SHOT-005-home-mobile.png` |
| LOG-019 | 12:46:41 | Evidence validation | File size verification | 6 screenshots present and non-empty | Screenshot size listing |

## Recoverable tool errors

- `click_element` repeatedly failed on multiple controls due pointer interception from overlapping elements.
- One Playwright snippet initially failed with `document is not defined`; corrected by using `page.evaluate`.
- A `mcp_chrome_devtoo_wait_for` call failed due wrong page-id system and was skipped; equivalent wait handled in Playwright.
