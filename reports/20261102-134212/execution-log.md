# Execution log

| ID | Time (local) | Area | Action | Result | Evidence |
|---|---|---|---|---|---|
| LOG-001 | 13:42:12 | Preflight | Create run folder and evidence dirs | Success | reports/20261102-134212/ |
| LOG-002 | 13:44:48 | Home | Capture baseline screenshot | Success | evidence/screenshots/SHOT-001-overview-desktop.png |
| LOG-003 | 13:46 | Login | Fill provided credentials + sign in | Success, redirected to #/ | evidence/screenshots/SHOT-002-authenticated-home.png |
| LOG-004 | 13:47 | Destination filter | Set destination Penang | Failed with user-visible HTTP 503 | evidence/screenshots/SHOT-003-penang-unavailable-503.png |
| LOG-005 | 13:47 | Destination filter | Set destination Langkawi | Success, 3 stays shown | snapshot state |
| LOG-006 | 13:47 | Sorting | Set sort to Price: low to high (Langkawi) | Success, ascending 520/680/890 | snapshot state |
| LOG-007 | 13:48 | Sorting | Set All destinations with Price: low to high | Success, ascending from 350 upward | evidence/screenshots/SHOT-004-all-destinations-price-asc.png |
| LOG-008 | 13:48 | Account profile | Open My account profile tab | Success | evidence/screenshots/SHOT-005-account-profile.png |
| LOG-009 | 13:48 | Account preferences | Open Travel preferences tab | Failed with HTTP 500 | evidence/screenshots/SHOT-006-account-preferences-500.png |
| LOG-010 | 13:49 | Account preferences | Click Try again (retry once) | Failed again with HTTP 500 | evidence/screenshots/SHOT-006-account-preferences-500.png |
| LOG-011 | 13:49 | Network capture | Export recent network list | Captured reqid 24 (503), 36/37 (500) | evidence/network/network-observations.md |
| LOG-012 | 13:49 | Console capture | Export console list | Captured 503 and 500 errors | evidence/console/console-observations.md |
| LOG-013 | 13:50 | Bookings | Open My bookings | Success, empty-state message shown | evidence/screenshots/SHOT-007-bookings-empty.png |
| LOG-014 | 13:50 | Saved | Open Saved stays + return to Discover | Success, empty-state shown | snapshot state |
| LOG-015 | 13:51 | Detail page | Open The Anda and press Tab (keyboard sample) | Success, keyboard focus visible | evidence/screenshots/SHOT-008-detail-keyboard-focus.png |
| LOG-016 | 13:51 | Mobile sample attempt | Resize to 390x844 | Blocked by DevTools protocol window state restriction | N/A |
| LOG-017 | 13:52:04 | Evidence check | Verify screenshot file set | 8 files present, non-empty | terminal output |
