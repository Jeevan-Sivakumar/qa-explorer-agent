# Network observations

Captured from Chrome DevTools MCP network list during this run.

## Relevant failed requests

1. reqid 24
- Method: GET
- Endpoint: /api/hotels?q=Penang&sort=recommended&pool=false
- Status: 503 Service Unavailable
- Trigger: selecting destination Penang
- User-visible reference: 71935166-15fa-4cec-a8e5-02d4a5649370

2. reqid 36
- Method: GET
- Endpoint: /api/account/preferences
- Status: 500 Internal Server Error
- Trigger: opening Travel preferences in account
- User-visible reference: 08af7301-4077-4818-bf04-04f846bd71b2

3. reqid 37
- Method: GET
- Endpoint: /api/account/preferences
- Status: 500 Internal Server Error
- Trigger: clicking Try again retry action
- User-visible reference: a2ff1265-3752-46e8-8962-8148e742154f

## Notes

- Durations and response bodies were not exported in this run.
- All three failures are corroborated by UI alerts and console errors.
