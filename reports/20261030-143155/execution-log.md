# Execution Log

Run: 20261030-143155  
Target: `http://localhost:3000/`  
Started: 2026-10-30 14:31:55 +08:00  
Finished: 2026-10-30 16:30:58 +08:00  
Browser: Chrome DevTools MCP. Individual action timestamps were not exposed; chronological IDs are used instead. The visible app was tested only through browser UI and browser-generated requests.

| Entry | Page/workflow | Action and observed result | Evidence |
|---|---|---|---|
| LOG-001 | Discover | Opened `http://localhost:3000/`; title and meaningful page content loaded. Initial document/API requests returned 200; no initial console messages. | EVID-001, NET-001 |
| LOG-002 | Discover | Initial listing showed eight stays and five destination options. | EVID-001 |
| LOG-003 | Destination: All destinations | Selected All destinations; eight stay cards displayed. | NET-001 |
| LOG-004 | Destination: Kuala Lumpur | Selected Kuala Lumpur; two Kuala Lumpur cards displayed. | NET-003 |
| LOG-005 | Destination: Penang | Selected Penang; Results unavailable alert and HTTP 503. First occurrence. | EVID-007, NET-004, CON-001 |
| LOG-006 | Destination: Penang | Repeated same selection; same 503 alert. Second occurrence. | NET-004 |
| LOG-007 | Destination: Langkawi | Selected Langkawi; three Langkawi cards displayed. | NET-005 |
| LOG-008 | Destination: Cameron Highlands | Selected Cameron Highlands; two matching cards displayed after loading. | NET-006 |
| LOG-009 | Destination: Penang | Re-selected Penang at a later point; same 503 alert. Third occurrence. | EVID-007, NET-004 |
| LOG-010 | Pool filter | With a pool showed four stays; All stays restored eight. | NET-007 |
| LOG-011 | Sort: Price: low to high | Eight cards ordered from RM 350 to RM 1,480 per night in ascending order. | NET-008 |
| LOG-012 | Sort: Highest rated | Eight cards ordered from 9.8 down to 9.1. | NET-009 |
| LOG-013 | Sort: Our favourites | Restored the default sort and verified the listing rendered. | EVID-001 |
| LOG-014 | Guests | Selected each Discover guest value, 1 through 6. All values were accepted by the selector. | CHECK-011 |
| LOG-015 | Find a stay | Clicked with Kuala Lumpur and a valid date range; page remained on Discover and scrolled to the filtered collection. No separate results route was observed. | CHECK-012 |
| LOG-016 | Refresh persistence | Set Kuala Lumpur, 2026-12-01 to 2026-12-04, three guests; refreshed. All values and two matching cards remained. | CHECK-014 |
| LOG-017 | The Moss House detail | Opened detail; location, nightly price, amenities, room and quote loaded. Stated maximum is four guests. | NET-010 |
| LOG-018 | The Moss House capacity | Selected six guests (also initially arrived from Discover with six). Quote returned 200, total RM 3,726.00, and Continue remained available despite the four-guest rule. Reproduced twice. | EVID-008, NET-011 |
| LOG-019 | Promotion STAY10 | Entered the published code and blurred the field; RM 345 discount appeared on RM 3,450 room subtotal, tax RM 248.40, total RM 3,353.40. | CHECK-017 |
| LOG-020 | Promotion PAST20 | Entered the published expired code and blurred; app rejected it with HTTP 422 and an invalid/expired message. | NET-012, CON-002 |
| LOG-021 | Date validation | Set checkout to 2026-11-30 while check-in was 2026-12-01; app returned HTTP 422 and no quote. Restored checkout to 2026-12-04. | EVID-009, NET-013, CON-002 |
| LOG-022 | Serena Villas detail | Opened comparison detail; it showed Swimming pool, up to four guests, RM 680 per night. | NET-014 |
| LOG-023 | Saved stays / My bookings | Both navigation links led to sign-in while anonymous. No credentials were supplied. | CHECK-020, CHECK-022 |
| LOG-024 | Sign-in validation | Submitted empty sign-in form; required-field validation blocked submission. | CHECK-021 |
| LOG-025 | Booking policies | Opened policy page; read visible refresh, capacity, and promotion rules used as expectations. | CHECK-014, CHECK-016, CHECK-017, CHECK-018 |
| LOG-026 | Mobile layout | Emulated 390 x 844 mobile viewport; visible search controls/action, no horizontal overflow. | EVID-005 |
| LOG-027 | Keyboard focus | Pressed Tab from page start; Skip to content received focus with a visible browser outline. Sampled accessibility check only. | EVID-006 |
| LOG-028 | Final state | Restored anonymous Discover defaults: All destinations, 2026-11-13 to 2026-11-16, two guests, Our favourites, All stays. | Final browser state |

Skipped: no account credentials, so no sign-in, saved items, reservation continuation, or post-login behavior was attempted. No reservation or payment action was submitted.