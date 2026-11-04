# Network observations

Run: 20261030-143155. Browser: Chrome DevTools MCP. Durations were not exposed by the available request listing and remain null.

| ID | Trigger | Method and sanitized endpoint | Status | Request reference | Result |
|---|---|---|---:|---|---|
| NET-001 | Initial Discover load | GET `/` | 200 | reqid 1 | Application document loaded. |
| NET-002 | Initial session lookup | GET `/api/session` | 200 | reqid 4, 5 | Anonymous session lookup completed. |
| NET-003 | Kuala Lumpur destination | GET `/api/hotels?q=Kuala+Lumpur&sort=recommended&pool=false` | 200 | reqid 13 | Two Kuala Lumpur stays shown. |
| NET-004 | Penang destination, three attempts | GET `/api/hotels?q=Penang&sort=recommended&pool=false` (first two); GET `/api/hotels?q=Penang&sort=rating&pool=false` (third) | 503 | reqid 14, 15, 82 | UI displayed Results unavailable and HTTP 503; no stays shown. Related finding QA-001. |
| NET-005 | Langkawi destination | GET `/api/hotels?q=Langkawi&sort=recommended&pool=false` | 200 | reqid 16 | Three Langkawi stays shown. |
| NET-006 | Cameron Highlands destination | GET `/api/hotels?q=Cameron+Highlands&sort=recommended&pool=false` | 200 | reqid 17 | Two Cameron Highlands stays shown. |
| NET-007 | Pool filter | GET `/api/hotels?q=&sort=recommended&pool=true` | 200 | reqid 19 | Four stays shown. |
| NET-008 | Sort by price | GET `/api/hotels?q=&sort=price&pool=false` | 200 | reqid 21 | Eight stays returned in ascending displayed price order. |
| NET-009 | Sort by rating | GET `/api/hotels?q=&sort=rating&pool=false` | 200 | reqid 22 | Eight stays returned in descending displayed rating order. |
| NET-010 | Moss House detail | GET `/api/hotels/moss-house` | 200 | reqid 25 | Detail and room data loaded. |
| NET-011 | Moss House quote with selected guests 6 | POST `/api/quote` | 200 | reqid 26 and later quote observations | Quote displayed RM 3,726.00 and Continue to reservation remained available despite the stated four-guest maximum. Related finding QA-002. |
| NET-012 | Promotion PAST20 | POST `/api/quote` | 422 | request ID not retained in the final listing | UI correctly identified the code as invalid or expired. |
| NET-013 | Checkout before check-in | POST `/api/quote` | 422 | request ID not retained in the final listing | UI displayed Stay must be between 1 and 30 nights; no quote was shown. |
| NET-014 | Serena Villas detail | GET `/api/hotels/serena-villas` | 200 | reqid 90 | Detail showed Swimming pool and up to four guests. |

No request bodies, cookies, authorization headers, or sensitive payloads are included. The browser request list did not expose durations or correlation IDs for these requests.