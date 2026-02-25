import '../models/cinema.dart';
import 'database_helper.dart';

class CinemaRepository {
  static final DatabaseHelper _dbHelper = DatabaseHelper();

  static Future<List<Cinema>> getCinemas() async {
    final cinemaMaps = await _dbHelper.getCinemas();
    List<Cinema> cinemas = [];

    for (var map in cinemaMaps) {
      final showtimeMaps = await _dbHelper.getShowtimes(map['name']);
      final showtimes = showtimeMaps.map((s) => Showtime.fromMap(s)).toList();
      cinemas.add(Cinema.fromMap(map, showtimes));
    }

    return cinemas;
  }
}
