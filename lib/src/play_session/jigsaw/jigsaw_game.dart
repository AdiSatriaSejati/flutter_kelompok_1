import 'dart:async'; // Mengimpor pustaka dart:async
import 'dart:io'; // Mengimpor pustaka dart:io
import 'dart:math' as math; // Mengimpor pustaka dart:math dengan alias math
import 'dart:math'; // Mengimpor pustaka dart:math
import 'dart:ui' as ui; // Mengimpor pustaka dart:ui dengan alias ui

import 'package:audioplayers/audioplayers.dart'; // Mengimpor paket audioplayers
import 'package:awesome_dialog/awesome_dialog.dart'; // Mengimpor paket awesome_dialog
import 'package:flame/components.dart'; // Mengimpor paket flame:components
import 'package:flame/extensions.dart'; // Mengimpor paket flame:extensions
import 'package:flame/game.dart'; // Mengimpor paket flame:game
import 'package:flame/image_composition.dart'; // Mengimpor paket flame:image_composition
import 'package:flame_audio/flame_audio.dart'; // Mengimpor paket flame_audio
import 'package:flutter_cache_manager/flutter_cache_manager.dart'; // Mengimpor paket flutter_cache_manager
import 'package:flutter_kelompok_1/src/level_selection/jigsaw_info.dart'; // Mengimpor file jigsaw_info.dart

import '../collision/puzzle_collision_detection.dart'; // Mengimpor file puzzle_collision_detection.dart
import '../shape_type.dart'; // Mengimpor file shape_type.dart
import 'image_utils.dart'; // Mengimpor file image_utils.dart
import 'piece_component.dart'; // Mengimpor file piece_component.dart

class JigsawGame extends FlameGame with HasCollisionDetection {
  int gridSize = 6; // Ukuran grid
  List<List<PieceComponent>> pieces = [
    []
  ]; // Daftar dua dimensi untuk menyimpan potongan puzzle
  List<Vector2> positions = []; // Daftar posisi vektor
  double pieceSize = 0; // Ukuran potongan puzzle
  JigsawInfo jigsawInfo; // Informasi jigsaw
  double _scale = 1.0; // Skala gambar
  bool isMusicOn; // Status musik
  Function win; // Fungsi untuk menang

  JigsawGame(this.jigsawInfo, this.isMusicOn, this.win); // Konstruktor

  @override
  Future<void> onLoad() async {
    collisionDetection =
        PuzzleCollisionDetection(); // Inisialisasi deteksi tabrakan
    // add(FpsTextComponent(position: Vector2(0, 50)));
    var file = await DefaultCacheManager()
        .getSingleFile(jigsawInfo.image); // Mengambil file gambar dari cache
    Image image = await getFileImage(file); // Mendapatkan gambar dari file
    _scale = ImageUtils.calculateScale(
        size.x / 3.0 * 2.0,
        size.y / 3.0 * 2.0,
        image.width.toDouble(),
        image.height.toDouble()); // Menghitung skala gambar
    print("scale:$_scale");
    gridSize = jigsawInfo.gridSize; // Mengatur ukuran grid
    final double widthPerBlock = image.width / gridSize; // Lebar per blok
    final double heightPerBlock = image.height / gridSize; // Tinggi per blok
    pieceSize = min(widthPerBlock, heightPerBlock) /
        4; // Mengatur ukuran potongan puzzle
    for (var y = 0; y < gridSize; y++) {
      final tmpPieces =
          <PieceComponent>[]; // Daftar sementara untuk menyimpan potongan puzzle
      pieces.add(tmpPieces); // Menambahkan daftar sementara ke daftar utama
      for (var x = 0; x < gridSize; x++) {
        PieceComponent player = getPiece(widthPerBlock, heightPerBlock, x, y,
            image); // Mendapatkan potongan puzzle
        pieces[y].add(player); // Menambahkan potongan puzzle ke daftar
      }
    }
    positions.shuffle(); // Mengacak posisi
    for (var y = 0; y < pieces.length; y++) {
      for (var x = 0; x < pieces[y].length; x++) {
        Vector2 position =
            positions[y * gridSize + x]; // Mengatur posisi potongan puzzle
        var piece = pieces[y][x];
        if (piece.shape.topTab == 0) {
          position.y = position.y + pieceSize * _scale;
        }
        if (piece.shape.leftTab == 0) {
          position.x = position.x + pieceSize * _scale;
        }
        position.x = position.x + positionOffsetX;
        piece.position = position; // Mengatur posisi potongan puzzle
        add(piece); // Menambahkan potongan puzzle ke game
      }
    }
  }

  getResult(int num, bool added) async {
    if (num == gridSize * gridSize) {
      print("getResult win:$num");
      win(); // Memanggil fungsi menang
      if (isMusicOn) {
        FlameAudio.play('won.wav'); // Memainkan suara kemenangan
      }
    } else {
      print("getResult isMusicOn:$isMusicOn");
      if (added && isMusicOn) {
        FlameAudio.play('click.wav'); // Memainkan suara klik
      }
    }
  }

  Future<Image> getFileImage(File filePath) async {
    var minHeight = (size.y / 3.0 * 2.0).toInt(); // Mengatur tinggi minimum
    var minWidth = (size.x / 3.0 * 2.0).toInt(); // Mengatur lebar minimum
    print("minHeight:$minHeight minWidth:$minWidth");
    // var list = await FlutterImageCompress.compressWithFile(
    //   filePath,
    //   minHeight: minHeight,
    //   minWidth: minWidth,
    //   quality: 99,
    //   rotate: 0,
    // );

    final Completer<ui.Image> completer =
        Completer(); // Membuat objek Completer
    ui.decodeImageFromList(filePath.readAsBytesSync(), (ui.Image img) {
      print("image width:${img.width} image height:${img.height}:");
      return completer.complete(img); // Menyelesaikan Completer dengan gambar
    });
    return completer.future; // Mengembalikan gambar
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size); // Memanggil metode onGameResize dari kelas induk
    print("onGameResize:$size");
  }

  PieceComponent getPiece(
      double widthPerBlock, double heightPerBlock, int x, int y, Image image) {
    Shape shape =
        _getShape(gridSize, x, y); // Mendapatkan bentuk potongan puzzle
    double xAxis = widthPerBlock * x; // Mengatur sumbu x
    double yAxis = heightPerBlock * y; // Mengatur sumbu y
    //相对于扩大后图片的起点
    xAxis -= shape.leftTab != 0 ? pieceSize : 0;
    yAxis -= shape.topTab != 0 ? pieceSize : 0;
    final double widthPerBlockTemp = widthPerBlock +
        (shape.leftTab != 0 ? pieceSize : 0) +
        (shape.rightTab != 0 ? pieceSize : 0); // Mengatur lebar blok sementara
    final double heightPerBlockTemp = heightPerBlock +
        (shape.topTab != 0 ? pieceSize : 0) +
        (shape.bottomTab != 0
            ? pieceSize
            : 0); // Mengatur tinggi blok sementara

    final piece = PieceComponent(
      SpriteComponent(
          sprite: Sprite(
            image,
            srcPosition: Vector2(xAxis, yAxis),
            srcSize: Vector2(widthPerBlockTemp, heightPerBlockTemp),
          ),
          size: Vector2(widthPerBlockTemp * _scale,
              heightPerBlockTemp * _scale)), // Membuat komponen sprite
      shape,
      pieceSize * _scale,
      x,
      y,
    );
    generatePositionBottom(widthPerBlock * _scale,
        heightPerBlock * _scale); // Menghasilkan posisi bawah
    return piece; // Mengembalikan potongan puzzle
  }

  ///
  /// 随机 1 凸起 2凹进去，0 平的
  Shape _getShape(int gridSize, int x, int y) {
    final int randomPosRow = math.Random().nextInt(2).isEven
        ? 1
        : -1; // Mendapatkan posisi acak baris
    final int randomPosCol = math.Random().nextInt(2).isEven
        ? 1
        : -1; // Mendapatkan posisi acak kolom
    Shape shape = Shape();
    shape.bottomTab =
        y == gridSize - 1 ? 0 : randomPosCol; // Mengatur tab bawah
    shape.leftTab =
        x == 0 ? 0 : -pieces[y][x - 1].shape.rightTab; // Mengatur tab kiri
    shape.rightTab = x == gridSize - 1 ? 0 : randomPosRow; // Mengatur tab kanan
    shape.topTab =
        y == 0 ? 0 : -pieces[y - 1][x].shape.bottomTab; // Mengatur tab atas
    return shape; // Mengembalikan bentuk
  }

  double pieceX = 0; // Posisi x potongan puzzle
  double pieceY = 0; // Posisi y potongan puzzle
  bool left = true; // Status kiri
  double positionOffsetX = -1; // Offset posisi x

  void generatePositionLeftRight(double widthPerBlock, double heightPerBlock) {
    int width = (widthPerBlock.toInt() + pieceSize * _scale * 2)
        .toInt(); // Mengatur lebar
    int height = (heightPerBlock.toInt() + pieceSize * _scale * 2)
        .toInt(); // Mengatur tinggi
    pieceY = pieceY + height; // Menambah posisi y
    if (positions.length == 0) {
      pieceY = 0;
    }
    if (pieceY + height > size.y) {
      if (left) {
        pieceX = size.x - pieceX - width; // Mengatur posisi x
        left = false;
      } else {
        pieceX = size.x - pieceX; // Mengatur posisi x
        left = true;
      }
      pieceY = 0;
    }
    // print(" pieceX:$pieceX pieceY:$pieceY");
    positions.add(Vector2(pieceX, pieceY)); // Menambahkan posisi ke daftar
  }

  void generatePositionBottom(double widthPerBlock, double heightPerBlock) {
    int width = (widthPerBlock.toInt() + pieceSize * _scale * 2)
        .toInt(); // Mengatur lebar
    int height = (heightPerBlock.toInt() + pieceSize * _scale * 2)
        .toInt(); // Mengatur tinggi
    pieceX = pieceX - width; // Mengurangi posisi x
    if (positions.length == 0) {
      pieceX = size.x - width; // Mengatur posisi x
      pieceY = size.y - height; // Mengatur posisi y
    }

    if (pieceX < 0) {
      if (positionOffsetX == -1) {
        positionOffsetX = -((pieceX + width) / 2.0); // Mengatur offset posisi x
      }
      pieceX = size.x - width; // Mengatur posisi x
      pieceY = pieceY - height; // Mengurangi posisi y
    }
    // print(" pieceX:$pieceX pieceY:$pieceY");
    positions.add(Vector2(pieceX, pieceY)); // Menambahkan posisi ke daftar
  }
}
