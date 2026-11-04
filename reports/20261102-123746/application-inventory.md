# Application inventory

## Pages and routes discovered

- `#/` Discover / home collection page
- `#/login` Sign-in and demo guest entry
- `#/saved` Saved stays page
- `#/hotel/the-anda` Hotel detail and pricing page
- `#/checkout` Reservation checkout form
- `#/bookings` Bookings list and cancellation
- `#/receipt/<reference>` Receipt route discovered (not exercised)
- `#/account/profile` Account profile route discovered (not exercised)
- `#/policies` Booking policies route discovered (not exercised)

## Primary workflows discovered

- Browse collection, filter, and sort stays
- Open hotel detail and review pricing breakdown
- Apply promotion code and validate errors
- Continue to checkout and confirm reservation
- View bookings and cancel reservation

## Finite options discovered

- Destination filter: All destinations, Kuala Lumpur, Penang, Langkawi, Cameron Highlands
- Guests filter: 1, 2, 3, 4, 5, 6
- Collection toggle: All stays, With a pool
- Sort by: Our favourites, Price: low to high, Highest rated
- Payment simulation: Successful payment, Declined payment
- Explore another stay selector: The Anda, Maison Vale, The Moss House, Serena Villas, The George, Highland Still, The Meranti, Rimba Terrace

## Exercised vs not exercised

- Exercised: Destination default (All destinations), Guests default (2), With a pool toggle, Sort option Price: low to high, Payment simulation default (Successful payment), one hotel path (The Anda)
- Not exercised: Destination non-default options, Guests non-default values, Sort Highest rated, Payment simulation Declined payment, non-The Anda hotel checkout paths, receipt page content, account profile, policies page