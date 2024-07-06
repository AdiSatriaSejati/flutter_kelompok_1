import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

// Fungsi untuk membangun transisi kustom
CustomTransitionPage<T> buildMyTransition<T>({
  required Widget child,
  required Color color,
  String? name,
  Object? arguments,
  String? restorationId,
  LocalKey? key,
}) {
  return CustomTransitionPage<T>(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return _MyReveal(
        animation: animation,
        color: color,
        child: child,
      );
    },
    key: key,
    name: name,
    arguments: arguments,
    restorationId: restorationId,
    transitionDuration: const Duration(milliseconds: 700), // Durasi transisi
  );
}

// Kelas StatefulWidget untuk transisi kustom
class _MyReveal extends StatefulWidget {
  final Widget child;
  final Animation<double> animation;
  final Color color;

  const _MyReveal({
    required this.child,
    required this.animation,
    required this.color,
  });

  @override
  State<_MyReveal> createState() => _MyRevealState();
}

// State untuk _MyReveal
class _MyRevealState extends State<_MyReveal> {
  static final _log =
      Logger('_InkRevealState'); // Logger untuk mencatat status animasi

  bool _finished = false; // Menyimpan status apakah animasi sudah selesai

  final _tween = Tween(
      begin: const Offset(0, -1),
      end: Offset.zero); // Tween untuk animasi slide

  @override
  void initState() {
    super.initState();
    widget.animation.addStatusListener(
        _statusListener); // Menambahkan listener untuk status animasi
  }

  @override
  void didUpdateWidget(covariant _MyReveal oldWidget) {
    if (oldWidget.animation != widget.animation) {
      oldWidget.animation.removeStatusListener(
          _statusListener); // Menghapus listener dari animasi lama
      widget.animation.addStatusListener(
          _statusListener); // Menambahkan listener ke animasi baru
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.animation.removeStatusListener(
        _statusListener); // Menghapus listener saat widget dihapus
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        SlideTransition(
          position: _tween.animate(
            CurvedAnimation(
              parent: widget.animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeOutCubic,
            ),
          ),
          child: Container(
            color: widget.color, // Warna latar belakang transisi
          ),
        ),
        AnimatedOpacity(
          opacity: _finished ? 1 : 0, // Opasitas berdasarkan status animasi
          duration:
              const Duration(milliseconds: 300), // Durasi animasi opasitas
          child: widget.child,
        ),
      ],
    );
  }

  // Listener untuk status animasi
  void _statusListener(AnimationStatus status) {
    _log.fine(() => 'status: $status'); // Mencatat status animasi
    switch (status) {
      case AnimationStatus.completed:
        setState(() {
          _finished = true; // Menandai animasi selesai
        });
      case AnimationStatus.forward:
      case AnimationStatus.dismissed:
      case AnimationStatus.reverse:
        setState(() {
          _finished = false; // Menandai animasi belum selesai
        });
    }
  }
}
