import '../models/booking.dart';
import 'database_helper.dart';

class BookingRepository {
  static final DatabaseHelper _dbHelper = DatabaseHelper();

  static Future<int> saveBooking(Booking booking) async {
    return await _dbHelper.saveBooking(booking.toMap());
  }

  static Future<List<Booking>> getBookings() async {
    final bookingMaps = await _dbHelper.getBookings();
    return bookingMaps.map((map) => Booking.fromMap(map)).toList();
  }

  static Future<int> getBookingCount() async {
    final bookingMaps = await _dbHelper.getBookings();
    return bookingMaps.length;
  }
}
