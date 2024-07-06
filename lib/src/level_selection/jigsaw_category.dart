// Kelas untuk kategori Jigsaw
class JigsawCategory {
  // Nama kategori dalam bahasa Inggris
  late String categoryEnname;
  // ID kategori
  late int id;
  // Nama kategori dalam bahasa lokal
  late String categoryName;

  // Konstruktor untuk inisialisasi JigsawCategory
  JigsawCategory(
    this.categoryEnname,
    this.id,
    this.categoryName,
  );

  // Konstruktor untuk inisialisasi JigsawCategory dari JSON
  JigsawCategory.fromJson(dynamic json) {
    print("json:${json}");
    categoryEnname = json['category_enname'];
    id = json['id'];
    categoryName = json['category_cnname'];
  }

  // Mengubah objek JigsawCategory menjadi map JSON
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['category_enname'] = categoryEnname;
    map['id'] = id;
    map['category_cnname'] = categoryName;
    return map;
  }
}
