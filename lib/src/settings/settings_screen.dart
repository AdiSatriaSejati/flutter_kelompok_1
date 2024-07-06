import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../style/palette.dart';
import 'settings.dart';

// Kelas SettingsScreen yang merupakan StatelessWidget
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _gap = SizedBox(height: 30);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    final palette = context.watch<Palette>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        }),
        centerTitle: true,
        backgroundColor: palette.backgroundMain,
        title: Text(
          'Pengaturan',
          style: TextStyle(fontSize: 28.sp, color: palette.textColor),
        ),
      ),
      backgroundColor: palette.backgroundMain,
      body: ListView(
        children: [
          _gap,
          // const _NameChangeLine(
          //   'Name',
          // ),
          // Menampilkan pengaturan suara dengan switch
          ValueListenableBuilder<bool>(
            valueListenable: settings.soundsOn,
            builder: (context, soundsOn, child) => _SettingsLine(
              'Suara',
              Switch(
                value: soundsOn,
                onChanged: (bool value) {
                  settings.toggleSoundsOn();
                },
              ), // Icon(soundsOn ? Icons.volume_up : Icons.volume_off),
              onSelected: () => settings.toggleSoundsOn(),
            ),
          ),
          // Menampilkan pengaturan privasi
          _SettingsLine(
            'Privasi',
            Container(),
            onSelected: () {
              _launchInBrowser(
                  Uri.parse("https://adisatriasejati.github.io/Home/"));
            },
          ),
          // Menampilkan pengaturan tentang
          _SettingsLine(
            'Tentang',
            Container(),
            onSelected: () {
              GoRouter.of(context).push('/settings/about');
            },
          ),
          _gap,
        ],
      ),
    );
  }
}

// Fungsi untuk membuka URL di browser
Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Tidak dapat membuka $url');
  }
}

// Kelas _SettingsLine yang merupakan StatelessWidget
class _SettingsLine extends StatelessWidget {
  final String title;

  final Widget icon;

  final VoidCallback? onSelected;

  const _SettingsLine(this.title, this.icon, {this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Colors.black12,
        width: 1,
      ))),
      child: InkResponse(
        onTap: onSelected,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20.sp,
                  ),
                ),
              ),
              icon,
            ],
          ),
        ),
      ),
    );
  }
}
