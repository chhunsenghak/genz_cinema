import 'package:flutter/foundation.dart';

import '../models/movie.dart';
import 'database_helper.dart';

class MovieRepository {
  static final DatabaseHelper _dbHelper = DatabaseHelper();

  static Future<List<Movie>> getMovies() async {
    try {
      final movieMaps = await _dbHelper.getMovies();
      final movies = movieMaps.map((map) => Movie.fromMap(map)).toList();

      // `sqflite` is not wired for web in this project; keep demo data visible.
      if (kIsWeb && movies.isEmpty) {
        return _webFallbackMovies;
      }

      return movies;
    } catch (_) {
      if (kIsWeb) {
        return _webFallbackMovies;
      }
      rethrow;
    }
  }

  // Backwards compatibility for now, though it should be replaced
  static List<Movie> get movies => [];

  static final List<Movie> _webFallbackMovies = [
    Movie(
      id: 1,
      title: 'Cyber Horizon',
      genre: 'Sci-Fi • Action',
      rating: 4.9,
      synopsis: 'In 2142, a hacker discovers a digital soul trapped in the global network.',
      imagePath:
          'https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?w=800&auto=format&fit=crop',
      bannerPath:
          'https://images.unsplash.com/photo-1614728263952-84ea206f99b6?w=1200&auto=format&fit=crop',
      ratingLimit: '16+',
    ),
    Movie(
      id: 2,
      title: 'Neon Spirits',
      genre: 'Cyberpunk • Fantasy',
      rating: 4.7,
      synopsis: 'Ancient spirits awakened in a world of circuits and light.',
      imagePath:
          'https://images.unsplash.com/photo-1578301978693-85fa9c0320b9?w=800&auto=format&fit=crop',
      bannerPath:
          'https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=1200&auto=format&fit=crop',
    ),
    Movie(
      id: 3,
      title: 'Quantum Echo',
      genre: 'Physics • Thriller',
      rating: 4.8,
      synopsis: 'When an experiment creates a localized time loop.',
      imagePath:
          'https://images.unsplash.com/photo-1614850523296-d8c1af93d400?w=800&auto=format&fit=crop',
      bannerPath:
          'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?w=1200&auto=format&fit=crop',
    ),
    Movie(
      id: 4,
      title: 'Glitch Paradise',
      genre: 'Adventure • Tech',
      rating: 4.5,
      synopsis: 'A luxury virtual resort begins to fragment.',
      imagePath:
          'https://images.unsplash.com/photo-1633356122544-f134324a6cee?w=800&auto=format&fit=crop',
      bannerPath:
          'https://images.unsplash.com/photo-1633356122102-3fe601e05bd2?w=1200&auto=format&fit=crop',
    ),
    Movie(
      id: 5,
      title: 'Virtual Valhalla',
      genre: 'Action • VR',
      rating: 4.6,
      synopsis: 'Legendary warriors battle in a simulated afterlife.',
      imagePath:
          'https://images.unsplash.com/photo-1616588589676-62b3bd4ff6d2?w=800&auto=format&fit=crop',
      bannerPath:
          'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=1200&auto=format&fit=crop',
    ),
  ];
}
