import 'package:flame/collisions.dart'; // Mengimpor paket flame untuk menangani tabrakan

import '../shape_type.dart'; // Mengimpor file shape_type.dart

class PuzzleHitbox extends RectangleHitbox {
  // Mendefinisikan kelas PuzzleHitbox yang merupakan turunan dari RectangleHitbox
  ShapeType type = ShapeType
      .top; // Mendeklarasikan variabel type dengan nilai default ShapeType.top
  int shapeTab = 0; // Mendeklarasikan variabel shapeTab dengan nilai default 0
  PuzzleHitbox(
    this.type, // Parameter konstruktor untuk inisialisasi type
    this.shapeTab, // Parameter konstruktor untuk inisialisasi shapeTab
    {
    super.position, // Parameter konstruktor untuk inisialisasi posisi
    super.size, // Parameter konstruktor untuk inisialisasi ukuran
    super.anchor, // Parameter konstruktor untuk inisialisasi anchor
  });

  void inactive() {
    // Fungsi untuk mengubah tipe tabrakan menjadi tidak aktif
    collisionType = CollisionType
        .inactive; // Mengatur collisionType menjadi CollisionType.inactive
  }
}
