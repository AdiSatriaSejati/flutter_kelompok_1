import 'package:flutter/material.dart';

/// Kelas untuk menangani pengecualian HTTP dan pesan kesalahan
class HttpException {
  String? message;
  HttpExceptionType _type;
  static String code401 = "401";
  static String code403 = "403";

  // Konstruktor untuk inisialisasi HttpException dengan tipe dan pesan opsional
  HttpException(this._type, {this.message = ""});

  // Mendapatkan tipe pengecualian
  get type => _type;

  @override
  String toString() {
    switch (_type) {
      case HttpExceptionType.noNetWork:
        return 'Tidak ada jaringan internet，Silakan periksa jaringan internet Anda';
      case HttpExceptionType.timeout:
        return 'Permintaan telah kadaluarsa，Silakan periksa jaringan internet Anda';
      case HttpExceptionType.requestError:
        return 'Permintaan gagal，Silakan periksa jaringan internet Anda';
      case HttpExceptionType.responseError:
        return "Permintaan gagal，Silakan periksa jaringan internet Anda";
      case HttpExceptionType.cancel:
        return 'Permintaan dibatalkan';
      case HttpExceptionType.netWorkCode:
      case HttpExceptionType.urlError:
        return 'Permintaan gagal，Silakan periksa jaringan internet Anda';
      case HttpExceptionType.unauthorized:
        return "Sesi login Anda sudah kadaluarsa，Silakan masuk kembali";
      case HttpExceptionType.other:
        return 'Permintaan gagal，Silakan periksa jaringan internet Anda';
      case HttpExceptionType.responseStatus:
        return message ??
            "Permintaan gagal，Silakan periksa jaringan internet Anda";
    }
  }
}

// Enum untuk mendefinisikan tipe-tipe pengecualian HTTP
enum HttpExceptionType {
  /// URL salah
  urlError,

  /// Tidak ada jaringan internet
  noNetWork,

  /// Permintaan gagal，Silakan periksa jaringan internet Anda
  timeout,

  /// Permintaan gagal，Silakan periksa jaringan internet Anda
  requestError,

  /// Permintaan gagal，Silakan periksa jaringan internet Anda
  responseError,

  /// Kode jaringan internet
  netWorkCode,

  /// Permintaan gagal，Silakan periksa jaringan internet Anda
  responseStatus,

  /// Permintaan dibatalkan
  cancel,

  /// Permintaan gagal，Silakan periksa jaringan internet Anda
  other,

  /// Sesi login Anda sudah kadaluarsa，Silakan masuk kembali
  unauthorized,
}
