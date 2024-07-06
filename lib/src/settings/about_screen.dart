import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../style/palette.dart';
import 'custom_name_dialog.dart';
import 'settings.dart';

// Kelas AboutScreen yang merupakan StatefulWidget
class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

// State untuk AboutScreen
class _AboutScreenState extends State<AboutScreen> {
  var _gap = SizedBox(height: 20.h); // Jarak antar widget
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo(); // Inisialisasi informasi paket
  }

  // Fungsi untuk inisialisasi informasi paket
  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

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
          style: TextStyle(fontSize: 40.sp, color: palette.textColor),
        ),
      ),
      backgroundColor: palette.backgroundMain,
      body: ListView(children: [
        _gap,
        Image(
          image: AssetImage('assets/images/ubsi.png'),
          width: 150.w,
          height: 150.w,
        ),
        _gap,
        Center(
            child:
                Text("${_packageInfo.appName}")), // Menampilkan nama aplikasi
        _gap,
        Center(
            child: Text(
                "Versi:${_packageInfo.version}")) // Menampilkan versi aplikasi
      ]),
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

// Kelas _NameChangeLine yang merupakan StatelessWidget
class _NameChangeLine extends StatelessWidget {
  final String title;

  const _NameChangeLine(this.title);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    return InkResponse(
      highlightShape: BoxShape.rectangle,
      onTap: () => showCustomNameDialog(
          context), // Menampilkan dialog untuk mengubah nama
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: const TextStyle(
                  fontSize: 30,
                )),
            const Spacer(),
            ValueListenableBuilder(
              valueListenable: settings.playerName,
              builder: (context, name, child) => Text(
                '‘$name’', // Menampilkan nama pemain
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
        onTap: onSelected, // Aksi ketika baris pengaturan dipilih
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
                    fontSize: 35.sp,
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
