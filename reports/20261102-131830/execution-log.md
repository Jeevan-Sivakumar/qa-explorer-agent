# Execution log

| Entry ID | Time (local) | Page/workflow | Action/tool | Observed result | Evidence |
|---|---|---|---|---|---|
| LOG-001 | 13:18:30 | Preflight | FS/template checks | New run directory and evidence folders created | `reports/20261102-131830/` |
| LOG-002 | 13:18:47 | Home | Screenshot capture | Desktop overview captured and non-empty | `evidence/screenshots/SHOT-001-overview-desktop.png` |
| LOG-003 | 13:19 | Home nav | Click `Saved stays` | Mouse click timed out | tool output |
| LOG-004 | 13:19 | Home nav | Keyboard Enter on `Saved stays` | Navigation succeeded to `#/saved` | `evidence/screenshots/SHOT-002-saved-page.png` |
| LOG-005 | 13:19 | Discover list | Verify low-to-high sort output | Display order not ascending: 890, 680, 1480, 780 | `evidence/screenshots/SHOT-003-sort-low-to-high-state.png` |
| LOG-006 | 13:19 | Discover -> Detail | Click `Explore stay` | Mouse click timed out | tool output |
| LOG-007 | 13:19 | Discover -> Detail | Keyboard Enter on hotel link | Reached `#/hotel/the-anda` | `evidence/screenshots/SHOT-004-detail-reservation-cta.png` |
| LOG-008 | 13:19 | Detail CTA | Click `Continue to reservation` | Mouse click timed out | tool output |
| LOG-009 | 13:19 | Detail CTA | Keyboard Enter on `Continue to reservation` | Reached `#/checkout` | state snapshot |
| LOG-010 | 13:20 | Mobile sample | Resize and capture | Home CTA visible at 390x844 | `evidence/screenshots/SHOT-005-home-mobile.png` |
| LOG-011 | 13:20:27 | Evidence validation | File size check | 5 screenshots present and non-empty | screenshot listing |
