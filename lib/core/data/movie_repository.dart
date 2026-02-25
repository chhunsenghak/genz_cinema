import '../models/movie.dart';
import 'database_helper.dart';

class MovieRepository {
  static final DatabaseHelper _dbHelper = DatabaseHelper();

  static Future<List<Movie>> getMovies() async {
    final movieMaps = await _dbHelper.getMovies();
    return movieMaps.map((map) => Movie.fromMap(map)).toList();
  }

  // Backwards compatibility for now, though it should be replaced
  static List<Movie> get movies => [];
}
