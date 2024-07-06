/// Kelas untuk menyimpan informasi versi aplikasi.
class Version {
  Version({
    required this.version,
    required this.versionName,
    required this.url,
    required this.playUrl,
  });

  /// Membuat instance dari JSON.
  Version.fromJson(dynamic json) {
    version = json['version'];
    versionName = json['versionName'];
    url = json['url'];
    playUrl = json['playUrl'];
  }

  late int version; // Versi aplikasi
  late String versionName; // Nama versi aplikasi
  late String url; // URL untuk versi aplikasi
  late String playUrl; // URL untuk mengunduh aplikasi dari Play Store

  /// Mengonversi instance ke JSON.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['version'] = version;
    map['versionName'] = versionName;
    map['url'] = url;
    map['playUrl'] = playUrl;
    return map;
  }
}
