import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../settings/settings.dart';
import '../style/responsive_screen.dart';
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  List<Color> colors = [
    Colors.blue,
    Colors.red
  ]; // Daftar warna untuk animasi gradien
  int index = 0; // Indeks untuk memilih warna
  double opacity = 0.0; // Opasitas untuk animasi teks

  @override
  void initState() {
    super.initState();
    // Timer untuk mengubah warna gradien setiap 2 detik
    Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        index = index == 0 ? 1 : 0;
      });
    });
    // Future untuk mengubah opasitas teks setelah 500 milidetik
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        opacity = 1.0;
      });
    });
  }

  // Fungsi untuk membuat widget nama dan id
  Widget buildNameTile(String name, String id) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: InkWell(
        child: Text(
          '$name ~ $id',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();

    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(
            seconds: 2), // Durasi animasi untuk perubahan warna gradien
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colors[index], colors[1 - index]], // Warna gradien
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ResponsiveScreen(
          mainAreaProminence: 0.45,
          squarishMainArea: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                    opacity: opacity, // Opasitas animasi teks
                    duration: Duration(seconds: 2), // Durasi animasi opasitas
                    child: Transform.rotate(
                      angle: -0.1, // Rotasi teks
                      child: TyperAnimatedTextKit(
                        text: ['Kelompok 1'],
                        textStyle: TextStyle(
                            fontSize: 55, height: 1, color: Colors.white),
                        speed: Duration(
                            milliseconds: 150), // Kecepatan animasi teks
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Menambahkan jarak
                  buildNameTile('ADI SATRIA SEJATI', '12221455'),
                  buildNameTile('ALBAR SANJI', '12220100'),
                  buildNameTile('MISBAH HAYATI', '12220146'),
                  buildNameTile('MUHAMMAD TAUFIQ RENDRADI', '12220204'),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: WavyAnimatedTextKit(
                      text: [
                        'Universitas Bina Sarana Informatika - Sistem Informasi'
                      ],
                      textStyle: TextStyle(color: Colors.white),
                      speed:
                          Duration(milliseconds: 150), // Kecepatan animasi teks
                    ),
                  ),
                ],
              ),
            ),
          ),
          rectangularMenuArea: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton(
                onPressed: () {
                  GoRouter.of(context)
                      .go('/play'); // Navigasi ke halaman bermain
                },
                child: const Text('Bermain'),
              ),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: () => GoRouter.of(context)
                    .push('/settings'), // Navigasi ke halaman pengaturan
                child: const Text('Pengaturan'),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: ValueListenableBuilder<bool>(
                  valueListenable: settingsController
                      .muted, // Mendengarkan perubahan status mute
                  builder: (context, muted, child) {
                    return IconButton(
                      onPressed: () => settingsController
                          .toggleSoundsOn(), // Mengubah status mute
                      icon: Icon(muted
                          ? Icons.volume_off
                          : Icons.volume_up), // Ikon berdasarkan status mute
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
