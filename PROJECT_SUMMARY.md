# GenZ Cinema — Project Summary

## What this project is
GenZ Cinema is a Flutter movie-ticketing style app with a modern, dark UI. It uses a local SQLite database (via `sqflite`) to store and serve app data like movies, cinemas, showtimes, snacks, and bookings.

## Key Features

### Authentication
- Entry flow starts at `AuthScreen` (basic auth gate / landing before the main app experience).

### Home (Movies)
- Loads movies asynchronously and renders:
  - **Featured** banner carousel
  - **Trending Now** horizontal list
  - **Top Rated** horizontal list
- “Glimpses” mode (vertical full-screen reels-like viewer) driven by the same movie data.

### Movie Detail
- Displays movie information and provides a path into booking.

### Booking Flow
- Cinema selection
- Seat selection
- Snack selection / combos
- Persists booking records to the local database

### Wallet / Tickets
- Lists bookings (most recent first)

### Search
- Search screen for browsing content

### Profile
- Profile screen (user/account style view)

### Notifications
- Notification list screen

## Data & Database

### Local SQLite (auto-created)
- The DB file is created automatically on first run: `genz_cinema.db`.
- Tables:
  - `movies`
  - `cinemas`
  - `showtimes`
  - `snacks`
  - `bookings`

### Seeding (demo content)
- Seeds a bulk set of movies (50 variants) with network images.
- Seeds cinemas, showtimes (for the first 5 movies), snacks, and a couple sample bookings.

### Reliability improvements applied
To prevent “No movies found” caused by existing/empty databases or schema drift:
- **Schema self-healing**: tables are created with `CREATE TABLE IF NOT EXISTS` on database open.
- **Idempotent seeding**: if a table is empty, seed runs again safely.
- **Upgrade resilience**: adding the `status` column to `bookings` won’t crash if it already exists.
- **Safer mapping**: `Movie.fromMap` tolerates `num` types and nulls so DB reads won’t throw.

## Desktop (Windows/Linux/macOS) SQLite Support
`sqflite` works on Android/iOS by default, but desktop needs an FFI backend.

Added:
- `sqflite_common_ffi`

Initialization:
- A small platform initializer enables SQLite on desktop while keeping web builds safe via conditional imports.

## How to run (quick)
- Install deps: `flutter pub get`
- Run on Windows: `flutter run -d windows`
- Run on Android emulator/device: `flutter run -d <deviceId>`

## Troubleshooting
If the home screen shows no movies:
1. Do a **full restart** (not hot reload) so DB initialization runs.
2. If you previously ran with an old DB state, uninstall/clear app data to reset the local DB.
3. The Home screen will now show a concrete error message if DB loading fails (instead of silently showing an empty list).

## What was changed in this session
- Improved DB initialization to ensure schema + seed runs reliably.
- Added desktop SQLite support using `sqflite_common_ffi`.
- Made `Movie.fromMap` more robust to DB type differences.
- Updated Home/Glimpses to surface DB load errors for faster debugging.
