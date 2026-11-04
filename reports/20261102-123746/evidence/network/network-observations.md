# Network observations

## Checked scope

- Promo-code validation during hotel detail pricing flow

## Observations

1. Action: Enter invalid/expired promo `PAST20` and blur input
   - Expected: Request rejected by server-side validation and surfaced to user
   - Observed: UI alert displayed `This promotion is invalid or expired.` with `HTTP 422` and a reference ID.
   - Browser/console corroboration: Resource error logged with status `422 Unprocessable Entity`.
   - Reference IDs observed in UI: `06c50f81-e09e-40d1-bfc3-35a7cb064bae`, `f11d3ec0-264e-4128-945b-31164905b772`

## Limitations

- Full request/response payload capture was not exported in this run; observations are based on UI error detail and browser console output linked to the triggering action.
