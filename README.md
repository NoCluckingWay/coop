# Coop Tracker

A mobile-friendly tracker for eggs, flock, hatch runs, feed, and coop supplies.

## Cloud setup

1. In the Supabase project, open **SQL Editor**, paste `supabase-setup.sql`, and run it once.
2. Under **Authentication > URL Configuration**, set **Site URL** to `https://nocluckingway.github.io/coop/` and add that same address to **Redirect URLs**.
3. Under **Authentication > Providers > Email**, leave Email enabled. Email confirmation is recommended.
4. Deploy these files from the `main` branch with GitHub Pages.

The Supabase URL and public browser key in `index.html` are safe to ship. Never add a secret or service-role key to this repository. Access to each user's record is enforced by the row-level security policies in `supabase-setup.sql`.

## Data behavior

- The first successful sign-in migrates the browser's existing `coopTrackerV1` record into the signed-in user's cloud row.
- Each signed-in user can read and change only their own row.
- Data remains cached locally for offline use and uploads after reconnecting.
- Updates use a row version check. If two devices edit the same version, the app asks which copy to keep instead of silently overwriting one.
- Realtime updates bring changes from another open device into the app.
