# Network observations

Source: Chrome DevTools MCP network request list during this run.

## Relevant failed requests

1. reqid 14
- Method: GET
- Endpoint: /api/hotels?q=Penang&sort=recommended&pool=false
- Status: 503
- Trigger: destination filter changed to Penang
- User-visible reference: 8db5ae14-acb9-4403-b17d-f8ecc501c8f6

2. reqid 24
- Method: GET
- Endpoint: /api/account/preferences
- Status: 500
- Trigger: open Travel preferences
- User-visible reference: 7ce2f140-9f55-41e1-80cc-add40f5b4c51

3. reqid 25
- Method: GET
- Endpoint: /api/account/preferences
- Status: 500
- Trigger: click Try again
- User-visible reference: 2c112c00-8e5c-471b-ba7a-185968cb850d

4. reqid 13
- Method: GET
- Endpoint: /assets/missing-rimba.svg
- Status: 500
- Trigger: rendering Rimba Terrace card image
- Impact: broken/failed visual asset on listing card

## Notes

- Full request/response bodies and durations were not exported by this run tooling.
