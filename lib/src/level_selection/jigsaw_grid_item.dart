import 'package:flutter/material.dart';
import 'package:flutter_kelompok_1/src/level_selection/jigsaw_info.dart';
import 'package:flutter_kelompok_1/src/level_selection/piece_image.dart';
import 'package:provider/provider.dart';

import '../style/palette.dart';

// Kelas untuk item grid Jigsaw
class JigsawGridItem extends StatelessWidget {
  const JigsawGridItem({
    required this.info,
    Key? key,
    this.onTap,
  }) : super(key: key);
  final JigsawInfo info;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: palette.backgroundMain,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            // Menampilkan gambar potongan Jigsaw
            PieceImage(pictureUrl: info.smallimage),
            Positioned(
              child: Container(
                  constraints: BoxConstraints(maxWidth: 150),
                  padding: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey,
                  ),
                  child: Text(
                    '@${info.photographer}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )),
              bottom: 2,
              right: 6,
            )
          ],
        ),
      ),
    );
  }
}
