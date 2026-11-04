# Console observations

## Checked scope

- Home, login, hotel detail promo validation, and checkout progression

## Messages observed

1. Time: ~12:41 local
   - Context: Entered invalid promo code `PAST20` and blurred field
   - Level: error
   - Message: `Failed to load resource: the server responded with a status of 422 (Unprocessable Entity)`
   - Assessment: Consistent with expected negative-path validation response for expired/invalid promotion.

## Notes

- No additional console exceptions were observed during successful reservation and cancellation paths.
- Console was sampled during active steps; this is not an exhaustive full-session console export.
