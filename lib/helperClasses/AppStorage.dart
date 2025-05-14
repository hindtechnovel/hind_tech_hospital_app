import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  // Save any value (String, int, bool, double)
  static Future<void> saveValue(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else {
      throw Exception("Unsupported value type");
    }
  }

  // Retrieve value
  static Future<dynamic> getValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key); // Returns dynamic (String/int/bool/etc.)
  }
}
