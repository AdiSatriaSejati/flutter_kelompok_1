import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../style/palette.dart';

// Tipe data untuk callback yang menerima nilai double
typedef DoubleCallback = void Function(double? p);

class PieceImage extends StatelessWidget {
  const PieceImage({
    super.key,
    required this.pictureUrl,
    this.progress,
    this.progressIndicatorBuilder,
  });

  final String pictureUrl; // URL gambar
  final Function? progress; // Fungsi untuk melacak progress
  final ProgressIndicatorBuilder?
      progressIndicatorBuilder; // Builder untuk indikator progress

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>(); // Mengambil palette dari context
    return CachedNetworkImage(
      imageUrl: pictureUrl, // URL gambar
      imageBuilder: (context, imageProvider) {
        progress?.call(); // Memanggil fungsi progress jika ada
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), // Membuat border radius
            image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover), // Menampilkan gambar dengan fit cover
          ),
        );
      },
      progressIndicatorBuilder: progressIndicatorBuilder ??
          (context, url, downloadProgress) {
            return Center(
                child: CircularProgressIndicator(
              color: palette.textColor, // Warna indikator progress
              value: downloadProgress.progress, // Nilai progress
            ));
          },
      errorWidget: (context, url, error) =>
          Icon(Icons.error), // Widget yang ditampilkan jika terjadi error
    );
  }
}
