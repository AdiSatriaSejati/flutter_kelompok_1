import 'dart:collection';
import 'dart:math';

import 'package:flutter/widgets.dart';

/// Menampilkan animasi confetti (perayaan): potongan kertas jatuh.
///
/// Widget ini mengisi ruang yang tersedia (seperti [SizedBox.expand]).
///
/// Ketika [isStopped] adalah `true`, animasi tidak akan berjalan. Ini berguna
/// ketika widget belum terlihat, misalnya. Berikan [colors]
/// untuk membuat animasi terlihat bagus dalam konteks.
///
/// Ini adalah port parsial dari CodePen oleh Hemn Chawroka:
/// https://codepen.io/iprodev/pen/azpWBr
class Confetti extends StatefulWidget {
  static const _defaultColors = [
    Color(0xffd10841),
    Color(0xff1d75fb),
    Color(0xff0050bc),
    Color(0xffa2dcc7),
  ];

  final bool isStopped;

  final List<Color> colors;

  const Confetti({
    this.colors = _defaultColors,
    this.isStopped = false,
    super.key,
  });

  @override
  State<Confetti> createState() => _ConfettiState();
}

class ConfettiPainter extends CustomPainter {
  final defaultPaint = Paint();

  final int snippingsCount = 200;

  late final List<_PaperSnipping> _snippings;

  Size? _size;

  DateTime _lastTime = DateTime.now();

  final UnmodifiableListView<Color> colors;

  ConfettiPainter(
      {required Listenable animation, required Iterable<Color> colors})
      : colors = UnmodifiableListView(colors),
        super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    if (_size == null) {
      // Pertama kali kita memiliki ukuran.
      _snippings = List.generate(
          snippingsCount,
          (i) => _PaperSnipping(
                frontColor: colors[i % colors.length],
                bounds: size,
              ));
    }

    final didResize = _size != null && _size != size;
    final now = DateTime.now();
    final dt = now.difference(_lastTime);
    for (final snipping in _snippings) {
      if (didResize) {
        snipping.updateBounds(size);
      }
      snipping.update(dt.inMilliseconds / 1000);
      snipping.draw(canvas);
    }

    _size = size;
    _lastTime = now;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _ConfettiState extends State<Confetti>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ConfettiPainter(
        colors: widget.colors,
        animation: _controller,
      ),
      willChange: true,
      child: const SizedBox.expand(),
    );
  }

  @override
  void didUpdateWidget(covariant Confetti oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isStopped && !widget.isStopped) {
      _controller.repeat();
    } else if (!oldWidget.isStopped && widget.isStopped) {
      _controller.stop(canceled: false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      // Kami tidak terlalu peduli dengan durasi, karena kami akan
      // menggunakan controller dalam loop.
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    if (!widget.isStopped) {
      _controller.repeat();
    }
  }
}

class _PaperSnipping {
  static final Random _random = Random();

  static const degToRad = pi / 180;

  static const backSideBlend = Color(0x70EEEEEE);

  // Ukuran area tempat potongan kertas bergerak.
  Size _bounds;

  // Posisi awal potongan kertas secara acak dalam area.
  late final _Vector position = _Vector(
    _random.nextDouble() * _bounds.width,
    _random.nextDouble() * _bounds.height,
  );

  // Kecepatan rotasi potongan kertas dalam derajat per detik.
  final double rotationSpeed = 800 + _random.nextDouble() * 600;

  // Sudut awal potongan kertas dalam derajat.
  final double angle = _random.nextDouble() * 360 * degToRad;

  // Rotasi potongan kertas dalam derajat.
  double rotation = _random.nextDouble() * 360 * degToRad;

  // Nilai cosinus sudut rotasi potongan kertas.
  double cosA = 1.0;

  // Ukuran potongan kertas.
  final double size = 7.0;

  // Kecepatan osilasi potongan kertas.
  final double oscillationSpeed = 0.5 + _random.nextDouble() * 1.5;

  // Kecepatan gerak potongan kertas secara horizontal.
  final double xSpeed = 40;

  // Kecepatan gerak potongan kertas secara vertikal.
  final double ySpeed = 50 + _random.nextDouble() * 60;

  // Titik sudut potongan kertas.
  late List<_Vector> corners = List.generate(4, (i) {
    final angle = this.angle + degToRad * (45 + i * 90);
    return _Vector(cos(angle), sin(angle));
  });

  // Waktu untuk menghitung osilasi potongan kertas.
  double time = _random.nextDouble();

  // Warna depan potongan kertas.
  final Color frontColor;

  // Warna belakang potongan kertas.
  late final Color backColor = Color.alphaBlend(backSideBlend, frontColor);

  // Kuas untuk menggambar potongan kertas.
  final paint = Paint()..style = PaintingStyle.fill;

  _PaperSnipping({
    required this.frontColor,
    required Size bounds,
  }) : _bounds = bounds;

  // Menggambar potongan kertas pada canvas.
  void draw(Canvas canvas) {
    if (cosA > 0) {
      paint.color = frontColor;
    } else {
      paint.color = backColor;
    }

    final path = Path()
      ..addPolygon(
        List.generate(
            4,
            (index) => Offset(
                  position.x + corners[index].x * size,
                  position.y + corners[index].y * size * cosA,
                )),
        true,
      );
    canvas.drawPath(path, paint);
  }

  // Memperbarui posisi dan rotasi potongan kertas berdasarkan waktu.
  void update(double dt) {
    time += dt;
    rotation += rotationSpeed * dt;
    cosA = cos(degToRad * rotation);
    position.x += cos(time * oscillationSpeed) * xSpeed * dt;
    position.y += ySpeed * dt;
    if (position.y > _bounds.height) {
      // Memindahkan potongan kembali ke atas.
      position.x = _random.nextDouble() * _bounds.width;
      position.y = 0;
    }
  }

  // Memperbarui ukuran area tempat potongan kertas bergerak.
  void updateBounds(Size newBounds) {
    if (!newBounds.contains(Offset(position.x, position.y))) {
      position.x = _random.nextDouble() * newBounds.width;
      position.y = _random.nextDouble() * newBounds.height;
    }
    _bounds = newBounds;
  }
}

class _Vector {
  double x, y;
  _Vector(this.x, this.y);
}
