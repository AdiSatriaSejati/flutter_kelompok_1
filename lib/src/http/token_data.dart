import 'package:shared_preferences/shared_preferences.dart';

class TokenData {
  // Konstanta untuk menyimpan kunci token
  static const String AM_AC_TOKEN = "token";

  // Fungsi untuk menyimpan AccessToken
  static saveAccessToken(String token) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(AM_AC_TOKEN, token);
  }

  // Fungsi untuk mendapatkan AccessToken
  static Future<String?> getAccessToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(AM_AC_TOKEN);
  }
}
