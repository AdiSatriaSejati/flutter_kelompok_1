import 'package:flutter/material.dart';

/// Palet warna yang digunakan dalam permainan.
///
/// Alasan kami tidak menggunakan sesuatu seperti `Theme` Material Design
/// adalah karena ini lebih sederhana untuk digunakan dan tetap memberikan
/// semua yang kami butuhkan untuk permainan.
///
/// Permainan umumnya memiliki palet warna yang lebih radikal daripada aplikasi. Misalnya,
/// setiap level permainan dapat memiliki warna yang sangat berbeda.
/// Pada saat yang sama, permainan jarang mendukung mode gelap.
///
/// Warna diambil dari palet yang menyenangkan ini:
/// https://lospec.com/palette-list/crayola84
///
/// Warna di sini diimplementasikan sebagai getter sehingga hot reloading berfungsi.
/// Dalam praktiknya, kita bisa saja mengimplementasikan warna
/// sebagai `static const`. Tetapi dengan cara ini palet lebih mudah diubah:
/// kita bisa memungkinkan pemain untuk menyesuaikan warna, misalnya,
/// atau bahkan mendapatkan warna dari jaringan.
class Palette {
  /// Warna latar belakang utama
  Color get backgroundMain => const Color(0xffFFE0B3);

  /// Warna teks
  Color get textColor => const Color(0xff482C2B);

  /// Warna tombol OK
  Color get btnOkColor => const Color(0xff9C4DCC);

  /// Warna tab yang dipilih
  Color get tabSelectColor => const Color(0xffFFC857);

  /// Warna tab yang tidak dipilih
  Color get tabUnSelectColor => const Color(0xffF9AFAF);
}
