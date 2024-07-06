/// Mengembalikan daftar nama file berdasarkan jenis efek suara (SfxType).
List<String> soundTypeToFilename(SfxType type) {
  switch (type) {
    case SfxType.click:
      return const [
        'click.wav',
      ];
  }
}

/// Mengontrol volume dari berbagai jenis efek suara (SfxType).
double soundTypeToVolume(SfxType type) {
  switch (type) {
    case SfxType.click:
      return 1.0;
  }
}

/// Jenis-jenis efek suara yang tersedia.
enum SfxType {
  click,
}
