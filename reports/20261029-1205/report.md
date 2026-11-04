# QA report — 20261029-1205

## Environment and scope

- **URL tested:** `http://localhost:3000`
- **Date/time (UTC+8):** 2026-10-29 11:55 to 12:09
- **Browser/tooling:** Chrome DevTools MCP (Chromium 156 user agent)
- **Viewport coverage:** Desktop 1440×900, Mobile 390×844
- **Network/CPU:** Normal (no throttling)
- **Authentication:** Anonymous session only (no test credentials provided)
- **Run duration:** ~14 minutes active testing
- **Authorized actions performed:** Read-only browsing plus simulated quote checks; no real payment or destructive action

## Health verdict

Core browsing, hotel details, sorting, and invalid-coupon handling work in the anonymous journey.  
One destination-specific availability failure was reproduced for Penang listing retrieval (HTTP 503) while other destinations in the same flow return data.

## Coverage

| ID | Feature / input / path | Expected | Actual | Outcome | Evidence |
|---|---|---|---|---|---|
| CHECK-001 | Home page load `/#/` | Homepage and catalog load successfully | Loaded with featured stays and filters | pass | DevTools snapshot (uid tree) |
| CHECK-002 | Main nav to Discover | Discover remains reachable | Navigates to `/#/` | pass | Nav interaction logs |
| CHECK-003 | Anonymous save action (`Save Serena Villas`) | Prompt for authentication | Redirected to `/#/login` | pass | UI redirect observed |
| CHECK-004 | Anonymous booking continue (`Continue to reservation`) | Prompt for authentication | Redirected to `/#/login` | pass | UI redirect observed |
| CHECK-005 | Login form required validation (blank submit) | Required field warning | Browser validation alert shown | pass | UI alert observed |
| CHECK-006 | Destination filter = Langkawi | Matching stays returned | 3 stays returned | pass | `GET /api/hotels?q=Langkawi&sort=price&pool=true` 200 |
| CHECK-007 | Sort = Price low to high | Ascending price order | RM 520 → RM 680 → RM 890 | pass | UI ordering observed |
| CHECK-008 | Destination filter = Penang | Matching stays returned | API error state shown | fail | `GET /api/hotels?q=Penang&sort=price&pool=true` 503, request id `2417b319-055b-42d9-a064-d976aa643058` |
| CHECK-009 | Invalid promo `PAST20` on hotel quote | Reject invalid/expired promo clearly | Inline alert + HTTP 422 shown | pass | `POST /api/quote` 422, request id `38f9fb28-4dea-4934-9b7c-62331ab57d32` |
| CHECK-010 | Mobile layout sample (390×844) | Key controls accessible | Navigation, form, and cards rendered/accessed | pass | Mobile snapshot observed |
| CHECK-011 | Keyboard-only sample | Focusable nav and actionable controls | Tab focus visible on top nav links | pass | Focus state observed in snapshot |
| CHECK-012 | Authenticated flows (saved list contents, booking creation, bookings list) | End-to-end signed-in flow should be testable | Blocked without credentials | blocked | Credential-dependent |

**Coverage totals:** 12 checks total = 10 pass, 1 fail, 1 blocked.

## Confirmed findings

### QA-001 — Penang destination listing unavailable (HTTP 503)
- **Category:** functional / availability
- **Severity:** medium
- **Impact:** Users filtering for Penang cannot browse available stays, causing a dead-end in destination discovery.
- **URL:** `http://localhost:3000/#/`
- **Preconditions:** Anonymous session on Discover page; destination and sort/filter controls visible.
- **Steps to reproduce:**
  1. Open Discover page.
  2. Keep “With a pool” toggle active and sort “Price: low to high”.
  3. Set destination to **Penang**.
- **Expected:** Penang stays list should render (or at minimum return available records if present in catalog scope).
- **Expected basis:** Destination filter semantics in UI; comparable destinations return filtered records.
- **Actual:** UI shows “Results unavailable” and alert with `HTTP 503`.
- **Comparison:** Same request shape for Langkawi returns HTTP 200 and renders 3 stays.
- **Reproducibility:** 1/1 in this run.
- **Confidence:** high.
- **Network evidence:** `GET /api/hotels?q=Penang&sort=price&pool=true` → 503, `x-request-id: 2417b319-055b-42d9-a064-d976aa643058`.

## Suspected issues and risk hypotheses

- No additional unconfirmed defects logged in this run.

## Performance observations

- No formal performance benchmark recorded in this session.
- Multiple API calls responded functionally in normal browsing, but no timing sample set (3+ comparable measurements) was captured.

## Blocked / not tested

- Authenticated workflows (actual sign-in success, saved stays list persistence, booking completion, booking management) were not tested due missing test credentials.
- Artifact screenshots could not be persisted to workspace paths via current DevTools file-save restrictions; evidence retained via runtime snapshots and request logs only.

## Next checks

1. Retest Penang listing endpoint behavior with and without pool filter to isolate whether failure is destination-specific or filter-combination specific.
2. Execute full authenticated booking workflow once test credentials are provided.
3. Capture timed performance samples (>=3) for `api/hotels` and `api/quote` under consistent conditions.
