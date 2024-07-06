import 'package:flutter_kelompok_1/src/http/http_engine.dart';

import 'dio_engine.dart';

// Kelas DioClient untuk mengelola instance dan melakukan request HTTP
class DioClient {
  // Variabel statis untuk menyimpan instance tunggal DioClient
  static DioClient? _instance;
  // Variabel untuk menyimpan instance HttpEngine
  late HttpEngine _engine;

  // Metode untuk mendapatkan instance DioClient
  static DioClient getInstance() {
    if (_instance == null) {
      _instance = DioClient._();
    }
    return _instance!;
  }

  // Konstruktor privat untuk inisialisasi DioClient
  DioClient._() {
    _engine = DioEngine();
  }

  // Metode untuk melakukan request GET
  Future get(String url, {Map<String, dynamic>? params}) async {
    try {
      // Melakukan request GET menggunakan _engine
      Map<String, dynamic> map = await _engine.get(url, params: params);
      return Future.value(map);
    } catch (e) {
      // Mengembalikan error jika terjadi kesalahan
      return Future.error(e);
    }
  }

  // Metode untuk melakukan request POST
  Future post(String url, {Map<String, dynamic>? params}) async {
    try {
      // Melakukan request GET (seharusnya POST) menggunakan _engine
      Map<String, dynamic> map = await _engine.get(url, params: params);
      // Mengembalikan error dengan map sebagai pesan error
      return Future.error(map);
    } catch (e) {
      // Mengembalikan error jika terjadi kesalahan
      return Future.error(e);
    }
  }
}
