import '../models/snack.dart';
import 'database_helper.dart';

class SnackRepository {
  static final DatabaseHelper _dbHelper = DatabaseHelper();

  static Future<List<Snack>> getSnacks() async {
    final snackMaps = await _dbHelper.getSnacks();
    return snackMaps.map((map) => Snack.fromMap(map)).toList();
  }
}
