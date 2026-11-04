# Execution log

| ID | Time (local) | Area | Action | Result | Evidence |
|---|---|---|---|---|---|
| LOG-001 | 10:20:42 | Preflight | Create run folder and evidence directories | Success | reports/20261103-102042/ |
| LOG-002 | 10:21:44 | Home | Capture desktop overview | Success | SHOT-001-overview-desktop.png |
| LOG-003 | 10:22 | Home | Set destination Penang | Failed with HTTP 503 user alert | SHOT-002-penang-filter.png |
| LOG-004 | 10:22 | Home | Reset destination to All destinations | Success | UI recovered to 9 stays |
| LOG-005 | 10:22 | Account | Open My account > Profile | Success | Profile details visible |
| LOG-006 | 10:22 | Account | Open Travel preferences | Failed with HTTP 500 | SHOT-003-account-preferences-500.png |
| LOG-007 | 10:22 | Account | Click Try again (single retry) | Failed again with HTTP 500 | SHOT-003-account-preferences-500.png |
| LOG-008 | 10:22 | Home | Return to discover list | Success | SHOT-004-home-broken-rimba-image.png |
| LOG-009 | 10:22 | Network | Collect network requests | Captured 503/500 and missing-rimba.svg 500 | evidence/network/network-observations.md |
| LOG-010 | 10:22 | Console | Collect console errors | 500/503 errors captured | evidence/console/console-observations.md |
| LOG-011 | 10:23 | Mobile sample | Resize to 390x844 and screenshot | Success | SHOT-005-home-mobile-390x844.png |
| LOG-012 | 10:23:36 | Validation | Verify screenshot files non-empty | 5 screenshots present | terminal output |
