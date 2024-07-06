import 'dart:collection';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

import '../settings/settings.dart';
import 'songs.dart';
import 'sounds.dart';

/// Mengizinkan pemutaran musik dan suara. Sebuah fasad untuk `package:audioplayers`.
class AudioController {
  static final _log = Logger('AudioController');

  final AudioPlayer _musicPlayer;

  /// Ini adalah daftar instance [AudioPlayer] yang diputar untuk memainkan
  /// efek suara.
  final List<AudioPlayer> _sfxPlayers;

  int _currentSfxPlayer = 0;

  final Queue<Song> _playlist;

  final Random _random = Random();

  SettingsController? _settings;

  ValueNotifier<AppLifecycleState>? _lifecycleNotifier;

  /// Membuat instance yang memutar musik dan suara.
  ///
  /// Gunakan [polyphony] untuk mengonfigurasi jumlah efek suara (SFX) yang dapat
  /// diputar pada saat yang sama. [polyphony] dari `1` akan selalu hanya memutar satu
  /// suara (suara baru akan menghentikan suara sebelumnya). Lihat diskusi
  /// tentang [_sfxPlayers] untuk mempelajari mengapa ini terjadi.
  ///
  /// Musik latar tidak termasuk dalam batas [polyphony]. Musik tidak akan
  /// pernah digantikan oleh efek suara karena itu akan konyol.
  AudioController({int polyphony = 2})
      : assert(polyphony >= 1),
        _musicPlayer = AudioPlayer(playerId: 'musicPlayer'),
        _sfxPlayers = Iterable.generate(
                polyphony, (i) => AudioPlayer(playerId: 'sfxPlayer#$i'))
            .toList(growable: false),
        _playlist = Queue.of(List<Song>.of(songs)..shuffle()) {
    _musicPlayer.onPlayerComplete.listen(_changeSong);
  }

  /// Mengizinkan [AudioController] untuk mendengarkan peristiwa [AppLifecycleState],
  /// dan oleh karena itu melakukan hal-hal seperti menghentikan pemutaran ketika permainan
  /// masuk ke latar belakang.
  void attachLifecycleNotifier(
      ValueNotifier<AppLifecycleState> lifecycleNotifier) {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);

    lifecycleNotifier.addListener(_handleAppLifecycle);
    _lifecycleNotifier = lifecycleNotifier;
  }

  /// Mengizinkan [AudioController] untuk melacak perubahan pada pengaturan.
  /// Yaitu, ketika salah satu dari [SettingsController.muted],
  /// [SettingsController.musicOn] atau [SettingsController.soundsOn] berubah,
  /// pengontrol audio akan bertindak sesuai.
  void attachSettings(SettingsController settingsController) {
    if (_settings == settingsController) {
      // Sudah terhubung ke instance ini. Tidak ada yang perlu dilakukan.
      return;
    }

    // Hapus handler dari pengontrol pengaturan lama jika ada
    final oldSettings = _settings;
    if (oldSettings != null) {
      oldSettings.muted.removeListener(_mutedHandler);
      oldSettings.musicOn.removeListener(_musicOnHandler);
      oldSettings.soundsOn.removeListener(_soundsOnHandler);
    }

    _settings = settingsController;

    // Tambahkan handler ke pengontrol pengaturan baru
    settingsController.muted.addListener(_mutedHandler);
    settingsController.musicOn.addListener(_musicOnHandler);
    settingsController.soundsOn.addListener(_soundsOnHandler);

    if (!settingsController.muted.value && settingsController.musicOn.value) {
      _startMusic();
    }
  }

  void dispose() {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);
    _stopAllSound();
    _musicPlayer.dispose();
    for (final player in _sfxPlayers) {
      player.dispose();
    }
  }

  /// Memuat semua efek suara sebelumnya.
  Future<void> initialize() async {
    _log.info('Memuat efek suara sebelumnya');
    // Ini mengasumsikan hanya ada sejumlah efek suara terbatas dalam permainan.
    // Jika ada ratusan file efek suara panjang, lebih baik
    // lebih selektif saat memuat sebelumnya.
    await AudioCache.instance.loadAll(SfxType.values
        .expand(soundTypeToFilename)
        .map((path) => 'sfx/$path')
        .toList());
  }

  /// Memutar satu efek suara, yang didefinisikan oleh [type].
  ///
  /// Pengontrol akan mengabaikan panggilan ini ketika pengaturan yang terlampir
  /// [SettingsController.muted] adalah `true` atau jika
  /// [SettingsController.soundsOn] adalah `false`.
  void playSfx(SfxType type) {
    final muted = _settings?.muted.value ?? true;
    if (muted) {
      _log.info(
          () => 'Mengabaikan pemutaran suara ($type) karena audio dibisukan.');
      return;
    }
    final soundsOn = _settings?.soundsOn.value ?? false;
    if (!soundsOn) {
      _log.info(
          () => 'Mengabaikan pemutaran suara ($type) karena suara dimatikan.');
      return;
    }

    _log.info(() => 'Memutar suara: $type');
    final options = soundTypeToFilename(type);
    final filename = options[_random.nextInt(options.length)];
    _log.info(() => '- Nama file yang dipilih: $filename');

    final currentPlayer = _sfxPlayers[_currentSfxPlayer];
    currentPlayer.play(AssetSource('sfx/$filename'),
        volume: soundTypeToVolume(type));
    _currentSfxPlayer = (_currentSfxPlayer + 1) % _sfxPlayers.length;
  }

  void _changeSong(void _) {
    _log.info('Lagu terakhir selesai diputar.');
    // Letakkan lagu yang baru saja selesai diputar di akhir daftar putar.
    _playlist.addLast(_playlist.removeFirst());
    // Putar lagu berikutnya.
    _playFirstSongInPlaylist();
  }

  void _handleAppLifecycle() {
    switch (_lifecycleNotifier!.value) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _stopAllSound();
      case AppLifecycleState.resumed:
        if (!_settings!.muted.value && _settings!.musicOn.value) {
          _resumeMusic();
        }
      case AppLifecycleState.inactive:
        // Tidak perlu bereaksi terhadap perubahan status ini.
        break;
      case AppLifecycleState.hidden:
    }
  }

  void _musicOnHandler() {
    if (_settings!.musicOn.value) {
      // Musik dinyalakan.
      if (!_settings!.muted.value) {
        _resumeMusic();
      }
    } else {
      // Musik dimatikan.
      _stopMusic();
    }
  }

  void _mutedHandler() {
    if (_settings!.muted.value) {
      // Semua suara baru saja dibisukan.
      _stopAllSound();
    } else {
      // Semua suara baru saja tidak dibisukan.
      if (_settings!.musicOn.value) {
        _resumeMusic();
      }
    }
  }

  Future<void> _playFirstSongInPlaylist() async {
    _log.info(() => 'Memutar ${_playlist.first} sekarang.');
    await _musicPlayer.play(AssetSource('music/${_playlist.first.filename}'));
  }

  Future<void> _resumeMusic() async {
    _log.info('Melanjutkan musik');
    switch (_musicPlayer.state) {
      case PlayerState.paused:
        _log.info('Memanggil _musicPlayer.resume()');
        try {
          await _musicPlayer.resume();
        } catch (e) {
          // Terkadang, melanjutkan gagal dengan kesalahan "Tidak Terduga".
          _log.severe(e);
          await _playFirstSongInPlaylist();
        }
      case PlayerState.stopped:
        _log.info("resumeMusic() dipanggil saat musik dihentikan. "
            "Ini mungkin berarti kita belum memulai musik. "
            "Misalnya, permainan dimulai dengan suara mati.");
        await _playFirstSongInPlaylist();
      case PlayerState.playing:
        _log.warning('resumeMusic() dipanggil saat musik sedang diputar. '
            'Tidak ada yang perlu dilakukan.');
      case PlayerState.completed:
        _log.warning('resumeMusic() dipanggil saat musik selesai. '
            "Musik seharusnya tidak pernah 'selesai' karena itu baik tidak diputar "
            "atau diputar berulang kali.");
        await _playFirstSongInPlaylist();
      case PlayerState.disposed:
    }
  }

  void _soundsOnHandler() {
    for (final player in _sfxPlayers) {
      if (player.state == PlayerState.playing) {
        player.stop();
      }
    }
  }

  void _startMusic() {
    _log.info('memulai musik');
    _playFirstSongInPlaylist();
  }

  void _stopAllSound() {
    if (_musicPlayer.state == PlayerState.playing) {
      _musicPlayer.pause();
    }
    for (final player in _sfxPlayers) {
      player.stop();
    }
  }

  void _stopMusic() {
    _log.info('Menghentikan musik');
    if (_musicPlayer.state == PlayerState.playing) {
      _musicPlayer.pause();
    }
  }
}
