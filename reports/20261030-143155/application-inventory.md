# Application Inventory

Run: 20261030-143155

## Application and pages

- **Stays.com Discover** at `http://localhost:3000/`: destination/date/guest form, stay cards, pool filter, sort selector, navigation to saved stays, bookings, sign-in, and booking policies.
- **Stay detail**: The Moss House and Serena Villas were opened. Both detail pages show a room, amenities, capacity, dates, guests, promotion input, quote, and Continue to reservation control.
- **Sign-in** at `#/login`: email and password are required; the page states that a test account must be supplied by a QA administrator.
- **Booking policies**: reached through the footer; published rules include guest/date persistence on refresh, a maximum guest count per room, a valid STAY10 promotion, and the expired PAST20 promotion.

## Finite controls discovered and exercised

- Destination: All destinations, Kuala Lumpur, Penang, Langkawi, Cameron Highlands. All five were selected. Penang returned 503 on three attempts; the other selections returned destination-matching cards.
- Guests: 1, 2, 3, 4, 5, 6. All six values were selected in the Discover form. The Moss House detail states a maximum of four but also permits 5 and 6 in its selector.
- Pool filter: All stays and With a pool. Both states were checked; the pool filter returned four stays. Serena Villas states Swimming pool; The Moss House states No swimming pool.
- Sort: Our favourites, Price: low to high, Highest rated. All three states were exercised. Price and rating orders matched their labels.
- Promotion examples: STAY10 was accepted and PAST20 was rejected as expired.

## Records discovered

The Anda (Langkawi), Maison Vale (Kuala Lumpur), The Moss House (Cameron Highlands), Serena Villas (Langkawi), The George (Penang), Highland Still (Cameron Highlands), The Meranti (Kuala Lumpur), and Rimba Terrace (Langkawi). The Moss House and Serena Villas detail pages were opened; other records were inspected as cards only.

## Access and remaining inventory

Saved stays and My bookings both lead to sign-in while anonymous. No test account was supplied, so authenticated account contents, saved-item persistence, reservation continuation, and post-login workflows were not exercised. The House rules & cancellation policy disclosure was discovered but not opened. The language/currency display and footer policies link were observed; only booking policies was opened.