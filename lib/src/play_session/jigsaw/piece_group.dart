import 'package:flutter_kelompok_1/src/play_session/jigsaw/piece_component.dart';

///
/// Menggunakan grup untuk mengelola semua potongan, potongan yang bersama-sama termasuk dalam grup yang sama
class PieceGroup {
  List<PieceComponent> children = [];

  // Konstruktor untuk menambahkan potongan ke dalam grup
  PieceGroup(PieceComponent child) {
    children.add(child);
  }

  // Metode untuk menambahkan potongan lain ke dalam grup
  add(PieceComponent other) {
    for (PieceComponent o in other.group.children) {
      if (!children.contains(o)) {
        children.add(o);
      }
      o.group = this;
    }
  }
}
