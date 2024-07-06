/// id : ""
/// difficulty : ""
/// pictureUrl : ""
/// title : ""
/// type : ""

class JigsawInfo {
  // ID Jigsaw
  late int id;
  // Ukuran grid Jigsaw
  late int gridSize;
  // URL gambar besar Jigsaw
  late String image;
  // URL gambar kecil Jigsaw
  late String smallimage;
  // Judul Jigsaw
  late String title;
  // Nama fotografer Jigsaw
  late String photographer;

  // Konstruktor untuk inisialisasi JigsawInfo
  JigsawInfo(this.image, this.smallimage, this.title);

  // Konstruktor untuk inisialisasi JigsawInfo dari JSON
  JigsawInfo.fromJson(dynamic json) {
    id = json['id'];
    image = json['src']['large'];
    smallimage = json['src']['medium'];
    title = json['alt'];
    photographer = json['photographer'];
  }
}
