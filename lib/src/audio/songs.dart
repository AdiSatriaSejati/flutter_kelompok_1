const Set<Song> songs = {
  // Nama file dengan spasi menyebabkan masalah pada package:audioplayers di iOS
  // (per Februari 2022), jadi kami tidak menggunakan spasi.
  Song('Mr_Smith-Azul.mp3', 'Azul', artist: 'Mr Smith'),
};

class Song {
  final String filename; // Nama file lagu

  final String name; // Nama lagu

  final String? artist; // Nama artis, opsional

  const Song(this.filename, this.name, {this.artist});

  @override
  String toString() =>
      'Song<$filename>'; // Mengembalikan representasi string dari objek Song
}
