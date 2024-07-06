class Api {
  // URL dasar untuk API Pexels
  static String url = 'https://api.pexels.com/v1/';

  // URL untuk gambar yang dikurasi
  static String image = url + '/curated';

  // Header untuk otorisasi API
  static Map<String, String> header = {
    "Authorization": "g6mSndHVfdFiwoLcNP1s18NPmAO1Oni4D1CYE386A9BNhWeIlL9ubFge"
  };
}
