# Application inventory

## Routes discovered

- `#/` home/discover
- `#/saved` saved stays
- `#/hotel/the-anda` hotel detail
- `#/checkout` checkout
- `#/bookings` bookings (discovered in nav, not exercised in this run)
- `#/account/profile` account profile (discovered in nav, not exercised)
- `#/policies` policies (discovered in footer, not exercised)

## Finite controls discovered

- Destination: All destinations, Kuala Lumpur, Penang, Langkawi, Cameron Highlands
- Guests: 1..6
- Collection toggle: All stays, With a pool
- Sort: Our favourites, Price: low to high, Highest rated
- Detail stay selector: 8 options
- Checkout payment simulation: Successful payment, Declined payment

## Exercised in this run

- Home load and signed-in nav presence
- Saved page navigation (keyboard path)
- Sort state validation for `Price: low to high`
- Detail page navigation and reservation CTA behavior
- Mobile sample on home at 390x844

## Not exercised in this run

- Checkout submission and post-booking lifecycle
- Payment decline path
- Policies, profile, and bookings content routes
- Destination/guest non-default combinations
