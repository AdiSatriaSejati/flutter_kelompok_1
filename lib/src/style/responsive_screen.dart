import 'package:flutter/material.dart';

/// Widget yang memudahkan untuk membuat layar dengan area utama yang berbentuk persegi,
/// area menu yang lebih kecil, dan area kecil untuk pesan di bagian atas.
/// Ini berfungsi dalam kedua orientasi pada layar berukuran ponsel dan tablet.
class ResponsiveScreen extends StatelessWidget {
  /// Ini adalah "hero" layar. Itu lebih atau kurang berbentuk persegi, dan akan
  /// diletakkan di tengah visual "center" layar.
  final Widget squarishMainArea;

  /// Area kedua terbesar setelah [squarishMainArea]. Itu dapat lebih pendek
  /// atau lebih lebar.
  final Widget rectangularMenuArea;

  /// Area yang direservasi untuk teks statis yang sangat dekat bagian atas layar.
  final Widget topMessageArea;

  /// Bagaimana besar lebih kecil [squarishMainArea] dibandingkan dengan elemen lainnya.
  final double mainAreaProminence;

  const ResponsiveScreen({
    required this.squarishMainArea,
    required this.rectangularMenuArea,
    this.topMessageArea = const SizedBox.shrink(),
    this.mainAreaProminence = 0.8,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Widget ini ingin mengisi layar penuh.
        final size = constraints.biggest;
        final padding = EdgeInsets.all(size.shortestSide / 30);

        if (size.height >= size.width) {
          // Mode "Potret" / "seluler".
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: padding,
                  child: topMessageArea,
                ),
              ),
              Expanded(
                flex: (mainAreaProminence * 100).round(),
                child: SafeArea(
                  top: false,
                  bottom: false,
                  minimum: padding,
                  child: squarishMainArea,
                ),
              ),
              SafeArea(
                top: false,
                maintainBottomViewPadding: true,
                child: Padding(
                  padding: padding,
                  child: rectangularMenuArea,
                ),
              ),
            ],
          );
        } else {
          // Mode "Lanskap" / "tablet".
          final isLarge = size.width > 900;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: isLarge ? 7 : 5,
                child: SafeArea(
                  right: false,
                  maintainBottomViewPadding: true,
                  minimum: padding,
                  child: squarishMainArea,
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    SafeArea(
                      bottom: false,
                      left: false,
                      maintainBottomViewPadding: true,
                      child: Padding(
                        padding: padding,
                        child: topMessageArea,
                      ),
                    ),
                    Expanded(
                      child: SafeArea(
                        top: false,
                        left: false,
                        maintainBottomViewPadding: true,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: padding,
                            child: rectangularMenuArea,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
