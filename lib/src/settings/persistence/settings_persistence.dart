/// Sebuah antarmuka untuk penyimpanan persisten untuk pengaturan.
///
/// Implementasi dapat berkisar dari penyimpanan sederhana dalam memori
/// melalui preferensi lokal hingga solusi berbasis cloud.
abstract class SettingsPersistence {
  /// Mendapatkan status musik apakah aktif atau tidak
  Future<bool> getMusicOn();

  /// Mendapatkan status mute dengan nilai default yang diperlukan
  Future<bool> getMuted({required bool defaultValue});

  /// Mendapatkan nama pemain
  Future<String> getPlayerName();

  /// Mendapatkan status suara apakah aktif atau tidak
  Future<bool> getSoundsOn();

  /// Menyimpan status musik
  Future<void> saveMusicOn(bool value);

  /// Menyimpan status mute
  Future<void> saveMuted(bool value);

  /// Menyimpan nama pemain
  Future<void> savePlayerName(String value);

  /// Menyimpan status suara
  Future<void> saveSoundsOn(bool value);
}
