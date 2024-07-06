import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file/file.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_kelompok_1/src/level_selection/jigsaw_info.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../games_services/score.dart';
import '../settings/settings.dart';
import '../style/palette.dart';
import 'animated_hide_widget.dart';
import 'jigsaw/jigsaw_game.dart';

class PlaySessionScreen extends StatefulWidget {
  final JigsawInfo level;

  const PlaySessionScreen(this.level, {super.key});

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen> {
  static final _log = Logger('PlaySessionScreen');

  static const _celebrationDuration = Duration(milliseconds: 2000);

  static const _preCelebrationDuration = Duration(milliseconds: 500);

  bool _duringCelebration = false;
  bool isLoading = true;

  late DateTime _startOfPlay;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final settingsController = context.watch<SettingsController>();
    return IgnorePointer(
      ignoring: _duringCelebration,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: BackButton(onPressed: () {
            Navigator.pop(context);
          }),
          centerTitle: true,
          backgroundColor: palette.backgroundMain,
          title: Text(
            'Puzzle ~ Kelompok 1',
            style: TextStyle(fontSize: 28.sp, color: palette.textColor),
          ),
          actions: [
            InkResponse(
              onTap: () {
                launchUrlString('');
              },
              child: Icon(
                Icons.code,
                size: 40.sp,
                color: palette.textColor,
              ),
            ),
            InkResponse(
              onTap: () {
                showReset();
              },
              child: Icon(
                Icons.restart_alt,
                size: 40.sp,
                color: palette.textColor,
              ),
            ),
            InkResponse(
              onTap: () {
                showImage();
              },
              child: Icon(
                Icons.image,
                size: 40.sp,
                color: palette.textColor,
              ),
            ),
            SizedBox(
              width: 16.w,
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: Stack(children: [
                  GameWidget(
                    loadingBuilder: (context) => Center(
                      child: CircularProgressIndicator(
                        color: palette.textColor,
                      ),
                    ),
                    game: JigsawGame(
                        widget.level, settingsController.soundsOn.value, () {
                      playerWon();
                    }),
                    backgroundBuilder: (context) => Container(
                      color: palette.backgroundMain,
                    ),
                  ),
                  // AnimatedHideWidget(
                  //   color: palette.backgroundMain,
                  // )
                ]),
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            SizedBox(
              height: 8.h,
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _startOfPlay = DateTime.now();

    // Preload iklan untuk layar kemenangan.
    // final adsRemoved =
    //     context.read<InAppPurchaseController?>()?.adRemoval.active ?? false;
    // if (!adsRemoved) {
    //   final adsController = context.read<AdsController?>();
    //   adsController?.preloadAd();
    // }
  }

  void showReset() async {
    AwesomeDialog(
        width: 400.h,
        dialogBackgroundColor: Palette().backgroundMain,
        btnOkColor: Palette().btnOkColor,
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.noHeader,
        headerAnimationLoop: false,
        title: 'Reset potongan?',
        btnOkText: 'Atur ulang',
        btnCancelText: 'Batal',
        btnCancelOnPress: () {},
        btnOkOnPress: () {
          setState(() {});
        }).show();
  }

  void showImage() async {
    File file = await DefaultCacheManager().getSingleFile(widget.level.image);
    AwesomeDialog(
      width: 400.h,
      context: context,
      animType: AnimType.scale,
      headerAnimationLoop: false,
      dialogType: DialogType.noHeader,
      body: Center(
        child: Container(
          width: 400.h,
          height: 300.h,
          padding: EdgeInsets.all(20.h),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Image.file(file, fit: BoxFit.contain),
        ),
      ),
    ).show();
  }

  Future<void> playerWon() async {
//   _log.info('Level ${widget.level.number} won');
//
    final score = Score(
      DateTime.now().difference(_startOfPlay),
    );
    AwesomeDialog(
      width: 400.h,
      bodyHeaderDistance: 0,
      padding: const EdgeInsets.all(0),
      dismissOnTouchOutside: false,
      context: context,
      animType: AnimType.scale,
      headerAnimationLoop: false,
      dialogType: DialogType.noHeader,
      body: Container(
        width: 400.h,
        height: 0.3.sh,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                height: 0.2.sh,
                child: Center(child: Lottie.asset('assets/lottie/win.json'))),
            Text(
              'Waktu: ${score.formattedTime}',
              style: TextStyle(fontSize: 16.sp, color: Palette().textColor),
            )
          ],
        ),
      ),
      dialogBackgroundColor: Palette().backgroundMain,
      btnOkColor: Palette().btnOkColor,
      btnOkText: "Lanjutkan",
      btnOkOnPress: () {
        GoRouter.of(context).go('/play');
      },
    ).show();

    // GoRouter.of(context).go('/play/won', extra: {'score': score});
  }

  Future<File> _getImage() async {
    File file = await DefaultCacheManager().getSingleFile(widget.level.image);
    return file;
  }
}
