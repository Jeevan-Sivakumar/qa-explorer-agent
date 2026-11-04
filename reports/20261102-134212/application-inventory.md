# Application inventory

## Routes exercised

- #/
- #/login
- #/saved
- #/bookings
- #/account/profile
- #/account/preferences
- #/hotel/the-anda

## Finite options discovered

- Destination: All destinations, Kuala Lumpur, Penang, Langkawi, Cameron Highlands
- Guests: 1, 2, 3, 4, 5, 6
- Sort: Our favourites, Price: low to high, Highest rated
- Account tabs: Profile, Travel preferences, My bookings
- Detail selector options: The Anda, Maison Vale, The Moss House, Serena Villas, The George, Highland Still, The Meranti, Rimba Terrace

## Distinct records inspected

- The George (Penang)
- The Anda (Langkawi)
- Maison Vale (Kuala Lumpur)
- Serena Villas (Langkawi)
- The Moss House (Cameron Highlands)
- Highland Still (Cameron Highlands)
- The Meranti (Kuala Lumpur)
- Rimba Terrace (Langkawi)

## Not exercised

- Full checkout transaction and cancellation lifecycle in this run (no explicit synthetic-transaction authorization response)
- Payment simulation variants
- 390x844 detail-page rendering (window resize blocked by browser state)
