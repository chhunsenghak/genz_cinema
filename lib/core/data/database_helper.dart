import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'genz_cinema.db');
    return await openDatabase(
      path,
      version: 2, // Bumped version for new schema
      onCreate: _onCreate,
      onOpen: (db) async {
        await _ensureSchema(db);
        await _ensureSeeded(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _ensureSchema(db);
          // Make upgrade resilient if the column already exists.
          try {
            await db.execute('ALTER TABLE bookings ADD COLUMN status TEXT');
          } catch (_) {
            // Ignore (e.g. "duplicate column name")
          }
          await _ensureSeeded(db);
        }
      },
    );
  }

  Future _onCreate(Database db, int version) async {
    await _ensureSchema(db);

    // Seed initial data
    await _seedData(db);
  }

  Future<void> _ensureSchema(Database db) async {
    // Movies Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS movies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT UNIQUE,
        rating REAL,
        genre TEXT,
        ratingLimit TEXT,
        synopsis TEXT,
        imagePath TEXT,
        bannerPath TEXT
      )
    ''');

    // Cinemas Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS cinemas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE,
        location TEXT,
        distance REAL,
        amenities TEXT
      )
    ''');

    // Showtimes Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS showtimes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        movieTitle TEXT,
        cinemaName TEXT,
        time TEXT,
        type TEXT,
        price REAL,
        FOREIGN KEY (movieTitle) REFERENCES movies (title) ON DELETE CASCADE,
        FOREIGN KEY (cinemaName) REFERENCES cinemas (name) ON DELETE CASCADE
      )
    ''');

    // Snacks Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS snacks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE,
        description TEXT,
        price REAL,
        imagePath TEXT,
        category TEXT
      )
    ''');

    // Bookings Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS bookings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        movieTitle TEXT,
        cinemaName TEXT,
        showtime TEXT,
        seats TEXT,
        snacks TEXT,
        totalPrice REAL,
        bookingDate TEXT,
        bannerPath TEXT,
        status TEXT
      )
    ''');
  }

  Future<void> _seedData(Database db) async {
    // Keep initial seeding idempotent.
    await _ensureSeeded(db);
  }

  Future<int> _countRows(Database db, String table) async {
    final result = await db.rawQuery('SELECT COUNT(*) as c FROM $table');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> _ensureSeeded(Database db) async {
    // Movies
    if (await _countRows(db, 'movies') == 0) {
      await _seedBulkMovies(db);
    }

    // Cinemas
    if (await _countRows(db, 'cinemas') == 0) {
      final cinemasRow = [
        {'name': 'Grand Cineplex', 'location': 'Downtown Mall, 5th Floor', 'distance': 1.2, 'amenities': 'IMAX,Dolby Atmos,Recliner'},
        {'name': 'Starlight Cinema', 'location': 'Riverside Walkway', 'distance': 3.5, 'amenities': '4DX,Standard'},
        {'name': 'Neo Galaxy Cinema', 'location': 'Tech Plaza, Level 3', 'distance': 0.8, 'amenities': 'IMAX,ScreenX'},
      ];

      for (var cinema in cinemasRow) {
        await db.insert('cinemas', cinema, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
    }

    // Showtimes (avoid duplicating rows on every open)
    if (await _countRows(db, 'showtimes') == 0) {
      final movies = await db.query('movies', limit: 5);
      for (var m in movies) {
        await db.insert('showtimes', {'movieTitle': m['title'], 'cinemaName': 'Grand Cineplex', 'time': '14:30', 'type': 'Standard', 'price': 10.0});
        await db.insert('showtimes', {'movieTitle': m['title'], 'cinemaName': 'Grand Cineplex', 'time': '17:00', 'type': 'IMAX', 'price': 15.0});
        await db.insert('showtimes', {'movieTitle': m['title'], 'cinemaName': 'Neo Galaxy Cinema', 'time': '16:30', 'type': 'IMAX', 'price': 14.0});
      }
    }

    // Snacks
    if (await _countRows(db, 'snacks') == 0) {
      final snacks = [
        {'name': 'Classic Combo', 'description': 'Large Popcorn + 2 Large Drinks', 'price': 15.0, 'imagePath': 'https://images.unsplash.com/photo-1572177191856-3cde618dee1f?w=400&auto=format&fit=crop', 'category': 'Combos'},
        {'name': 'Solo Pack', 'description': 'Medium Popcorn + 1 Small Drink', 'price': 8.5, 'imagePath': 'https://images.unsplash.com/photo-1594463750939-ebb28c3f5f53?w=400&auto=format&fit=crop', 'category': 'Combos'},
        {'name': 'Caramel Popcorn', 'description': 'Large Sweet Caramel Glazed', 'price': 7.0, 'imagePath': 'https://images.unsplash.com/photo-1541416637380-60b1e4c7ba08?w=400&auto=format&fit=crop', 'category': 'Popcorn'},
        {'name': 'Salted Popcorn', 'description': 'Medium Classic Sea Salt', 'price': 5.5, 'imagePath': 'https://images.unsplash.com/photo-1505686994434-e3cc5abf1330?w=400&auto=format&fit=crop', 'category': 'Popcorn'},
        {'name': 'Coca Cola', 'description': 'Large Chilled Fountain Soda', 'price': 4.5, 'imagePath': 'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=400&auto=format&fit=crop', 'category': 'Drinks'},
        {'name': 'Nachos with Cheese', 'description': 'Crunchy Nachos with Liquid Jalapeno Cheese', 'price': 6.5, 'imagePath': 'https://images.unsplash.com/photo-1513456852971-30c0b8199d4d?w=400&auto=format&fit=crop', 'category': 'Snacks'},
      ];

      for (var snack in snacks) {
        await db.insert('snacks', snack, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
    }

    // Bookings (avoid duplicating demo bookings)
    if (await _countRows(db, 'bookings') == 0) {
      await _seedSampleBookings(db);
    }
  }

  Future<void> _seedBulkMovies(Database db) async {
    final baseMovies = [
      {'title': 'Cyber Horizon', 'genre': 'Sci-Fi • Action', 'rating': 4.9, 'synopsis': 'In 2142, a hacker discovers a digital soul trapped in the global network.', 'imagePath': 'https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?w=800&auto=format&fit=crop', 'bannerPath': 'https://images.unsplash.com/photo-1614728263952-84ea206f99b6?w=1200&auto=format&fit=crop', 'ratingLimit': '16+'},
      {'title': 'Neon Spirits', 'genre': 'Cyberpunk • Fantasy', 'rating': 4.7, 'synopsis': 'Ancient spirits awakened in a world of circuits and light.', 'imagePath': 'https://images.unsplash.com/photo-1578301978693-85fa9c0320b9?w=800&auto=format&fit=crop', 'bannerPath': 'https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=1200&auto=format&fit=crop', 'ratingLimit': '13+'},
      {'title': 'Quantum Echo', 'genre': 'Physics • Thriller', 'rating': 4.8, 'synopsis': 'When an experiment creates a localized time loop.', 'imagePath': 'https://images.unsplash.com/photo-1614850523296-d8c1af93d400?w=800&auto=format&fit=crop', 'bannerPath': 'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?w=1200&auto=format&fit=crop', 'ratingLimit': '13+'},
      {'title': 'Glitch Paradise', 'genre': 'Adventure • Tech', 'rating': 4.5, 'synopsis': 'A luxury virtual resort begins to fragment.', 'imagePath': 'https://images.unsplash.com/photo-1633356122544-f134324a6cee?w=800&auto=format&fit=crop', 'bannerPath': 'https://images.unsplash.com/photo-1633356122102-3fe601e05bd2?w=1200&auto=format&fit=crop', 'ratingLimit': '13+'},
      {'title': 'Virtual Valhalla', 'genre': 'Action • VR', 'rating': 4.6, 'synopsis': 'Legendary warriors battle in a simulated afterlife.', 'imagePath': 'https://images.unsplash.com/photo-1616588589676-62b3bd4ff6d2?w=800&auto=format&fit=crop', 'bannerPath': 'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=1200&auto=format&fit=crop', 'ratingLimit': '13+'},
    ];

    // Duplicate and variate to get 50
    for (int i = 0; i < 50; i++) {
      final base = baseMovies[i % baseMovies.length];
      await db.insert('movies', {
        ...base,
        'title': '${base['title']} ${i + 1}',
        'rating': (4.0 + (i % 10) / 10).toDouble(),
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }

  Future<void> _seedSampleBookings(Database db) async {
    final now = DateTime.now();
    final sampleBookings = [
      {
        'movieTitle': 'Cyber Horizon 1',
        'cinemaName': 'Grand Cineplex',
        'showtime': '17:00 • IMAX',
        'seats': 'F1,F2',
        'snacks': '1 x Classic Combo',
        'totalPrice': 45.0,
        'bookingDate': now.subtract(const Duration(days: 2)).toIso8601String(),
        'bannerPath': 'https://images.unsplash.com/photo-1614728263952-84ea206f99b6?w=1200&auto=format&fit=crop',
        'status': 'used'
      },
      {
        'movieTitle': 'Neon Spirits 2',
        'cinemaName': 'Starlight Cinema',
        'showtime': '15:45 • 4DX',
        'seats': 'A4',
        'snacks': 'None',
        'totalPrice': 18.0,
        'bookingDate': now.add(const Duration(days: 1)).toIso8601String(),
        'bannerPath': 'https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=1200&auto=format&fit=crop',
        'status': 'pending'
      }
    ];

    for (var booking in sampleBookings) {
      await db.insert('bookings', booking, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }

  // Query Methods
  Future<List<Map<String, dynamic>>> getMovies() async {
    final db = await database;
    return await db.query('movies');
  }

  Future<List<Map<String, dynamic>>> getCinemas() async {
    final db = await database;
    return await db.query('cinemas');
  }

  Future<List<Map<String, dynamic>>> getShowtimes(String cinemaName) async {
    final db = await database;
    return await db.query('showtimes', where: 'cinemaName = ?', whereArgs: [cinemaName]);
  }

  Future<List<Map<String, dynamic>>> getSnacks() async {
    final db = await database;
    return await db.query('snacks');
  }

  Future<int> saveBooking(Map<String, dynamic> booking) async {
    final db = await database;
    return await db.insert('bookings', booking);
  }

  Future<List<Map<String, dynamic>>> getBookings() async {
    final db = await database;
    return await db.query('bookings', orderBy: 'id DESC');
  }
}
