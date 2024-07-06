import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../level_selection/jigsaw_info.dart';
import '../level_selection/piece_image.dart';

class LoadingSelectionScreen extends StatefulWidget {
  final JigsawInfo level;

  const LoadingSelectionScreen({super.key, required this.level});

  @override
  State<LoadingSelectionScreen> createState() => _LoadingSelectionScreenState();
}

// Kelas untuk mengatur state dari LoadingSelectionScreen
class _LoadingSelectionScreenState extends State<LoadingSelectionScreen> {
  double p = 0;
  int date = 0;

  @override
  void initState() {
    super.initState();
    // Mengambil waktu saat ini dalam microseconds sejak epoch
    date = DateTime.now().microsecondsSinceEpoch;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1.sw, // Mengatur lebar container sesuai dengan lebar layar
        height: 1.sh, // Mengatur tinggi container sesuai dengan tinggi layar
        child: Stack(children: [
          // Menampilkan gambar kecil dari level
          PieceImage(
            pictureUrl: widget.level.smallimage,
          ),
          // Menampilkan gambar besar dari level dengan progress indicator
          PieceImage(
            pictureUrl: widget.level.image,
            progressIndicatorBuilder: (context, url, downloadProgress) {
              return Container();
            },
            progress: () {
              print("complete: $p");
              int now = DateTime.now().microsecondsSinceEpoch;
              print('now $now');
              print('date $date');
              print('diff ${now - date}');
              print("complete: 22");
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Menunda selama 1500 milidetik sebelum berpindah ke halaman sesi permainan
                Future.delayed(Duration(milliseconds: 1500), () async {
                  GoRouter.of(context)
                      .go('/play/session/', extra: widget.level);
                });
              });
            },
          ),
          // Jika adsControllerAvailable bernilai true, maka tampilkan iklan banner
          // if (adsControllerAvailable) ...[
          //   Container(
          //     height: 80.h,
          //     color: Colors.white,
          //     child: Center(child: BannerAdWidget()),
          //   )
          // ],
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 0.1.sh),
              width: 0.9.sw,
              child: Stack(alignment: Alignment.center, children: [
                Container(
                  height: 30.h,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  ),
                ),
                Text(
                  "Memuat...", // Menampilkan teks "Memuat..." di tengah progress bar
                )
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
