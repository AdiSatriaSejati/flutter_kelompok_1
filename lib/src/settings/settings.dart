import 'package:flutter/foundation.dart';

import 'persistence/settings_persistence.dart';

/// Kelas yang menyimpan pengaturan seperti [playerName] atau [musicOn],
/// dan menyimpannya ke penyimpanan yang diinjeksikan.
class SettingsController {
  final SettingsPersistence _persistence;

  /// Apakah suara sepenuhnya dimatikan atau tidak. Ini menimpa baik musik
  /// maupun suara.
  ValueNotifier<bool> muted = ValueNotifier(false);

  /// Nama pemain
  ValueNotifier<String> playerName = ValueNotifier('Player');

  /// Apakah suara dihidupkan atau tidak
  ValueNotifier<bool> soundsOn = ValueNotifier(false);

  /// Apakah musik dihidupkan atau tidak
  ValueNotifier<bool> musicOn = ValueNotifier(false);

  /// Membuat instance baru dari [SettingsController] yang didukung oleh [persistence].
  SettingsController({required SettingsPersistence persistence})
      : _persistence = persistence;

  /// Memuat nilai secara asinkron dari penyimpanan yang diinjeksikan.
  Future<void> loadStateFromPersistence() async {
    await Future.wait([
      _persistence
          // Di web, suara hanya bisa dimulai setelah interaksi pengguna, jadi
          // kita mulai dalam keadaan mute di sana.
          // Di platform lain, kita mulai dalam keadaan tidak mute.
          .getMuted(defaultValue: kIsWeb)
          .then((value) => muted.value = value),
      _persistence.getSoundsOn().then((value) => soundsOn.value = value),
      _persistence.getMusicOn().then((value) => musicOn.value = false),
      _persistence.getPlayerName().then((value) => playerName.value = value),
    ]);
  }

  /// Mengatur nama pemain
  void setPlayerName(String name) {
    playerName.value = name;
    _persistence.savePlayerName(playerName.value);
  }

  // void toggleMusicOn() {
  //   musicOn.value = !musicOn.value;
  //   print("SettingsController toggleMusicOn:${musicOn.value}");
  //   _persistence.saveMusicOn(musicOn.value);
  // }

  /// Mengubah status mute
  void toggleMuted() {
    muted.value = !muted.value;
    _persistence.saveMuted(muted.value);
  }

  /// Mengubah status suara
  void toggleSoundsOn() {
    soundsOn.value = !soundsOn.value;
    _persistence.saveSoundsOn(soundsOn.value);
  }
}
