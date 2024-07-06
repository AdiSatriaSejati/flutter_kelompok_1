import 'package:flutter/material.dart';

/// Menampilkan [message] dalam snack bar selama [ScaffoldMessengerState]
/// dengan kunci global [scaffoldMessengerKey] ada di mana saja di pohon widget.
void showSnackBar(String message) {
  final messenger = scaffoldMessengerKey.currentState;
  messenger?.showSnackBar(
    SnackBar(content: Text(message)),
  );
}

/// Gunakan ini saat membuat [MaterialApp] jika Anda ingin [showSnackBar] berfungsi.
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey(debugLabel: 'scaffoldMessengerKey');
