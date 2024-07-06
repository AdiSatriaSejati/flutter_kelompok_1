import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Utilitas untuk menyimpan dan mengambil data dari SharedPreferences.
class SpUtil {
  SpUtil._internal();
  static final SpUtil _instance = SpUtil._internal();

  factory SpUtil() {
    return _instance;
  }

  SharedPreferences? prefs;

  /// Inisialisasi SharedPreferences.
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  /// Menyimpan data JSON.
  Future<bool> setJSON(String key, dynamic jsonVal) {
    String jsonString = jsonEncode(jsonVal);
    return prefs!.setString(key, jsonString);
  }

  /// Mengambil data JSON.
  dynamic getJSON(String key) {
    String? jsonString = prefs?.getString(key);
    return jsonString == null ? null : jsonDecode(jsonString);
  }

  /// Menyimpan nilai boolean.
  Future<bool> setBool(String key, bool val) {
    return prefs!.setBool(key, val);
  }

  /// Mengambil nilai boolean.
  bool? getBool(String key) {
    return prefs!.getBool(key);
  }

  /// Menghapus nilai berdasarkan kunci.
  Future<bool> remove(String key) {
    return prefs!.remove(key);
  }
}
