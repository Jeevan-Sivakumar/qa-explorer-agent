# Console observations

Run: 20261030-143155. Browser: Chrome DevTools MCP.

| ID | Trigger | Observation | Related check/finding |
|---|---|---|---|
| CON-001 | Penang destination filter | `Failed to load resource: the server responded with a status of 503 (Service Unavailable)`. DevTools grouped repeated messages; the same UI failure was reproduced three times. | CHECK-004, QA-001 |
| CON-002 | Expired promotion and invalid checkout checks | A 422 response was observed for quote validation. The app presented a specific in-page alert for each invalid input. | CHECK-018, CHECK-019 |

An initial console inspection found no messages. Later inspected messages were associated with the observed 503/422 responses; no other console errors or warnings were observed in the final sampled view. This is not a claim that the console was empty throughout the run.