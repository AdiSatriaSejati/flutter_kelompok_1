import 'dart:math';

import 'package:flame/components.dart';

class ImageUtils {
  // Fungsi untuk menghitung skala gambar berdasarkan ukuran target dan ukuran gambar asli
  static double calculateScale(double targetSizeWidth, double targetSizeHeight,
      double imageSizeWidth, double imageSizeHeight) {
    double scale = 1.0;
    if (imageSizeWidth > targetSizeWidth ||
        imageSizeHeight > targetSizeHeight) {
      scale = min(
          targetSizeWidth / imageSizeWidth, targetSizeHeight / imageSizeHeight);
    } else {
      scale = max(
          targetSizeWidth / imageSizeWidth, targetSizeHeight / imageSizeHeight);
    }
    return scale;
  }

  // Fungsi untuk menyesuaikan gambar agar pas di tengah berdasarkan ukuran target
  static Vector2 fitCenter(
      double width, double height, double targetWidth, double targetHeight) {
    print("image.width:${width} image.height:${height}");

    double original_aspect_ratio = 1.0;
    double target_aspect_ratio = 1.0;
    double new_width = 0.0;
    double new_height = 0.0;

    // Menghitung rasio aspek gambar asli dan ukuran target
    original_aspect_ratio = width / height;
    target_aspect_ratio = targetWidth / targetHeight;

    // Jika rasio aspek asli lebih besar dari rasio aspek target, maka perlu mengubah skala lebar
    if (original_aspect_ratio > target_aspect_ratio) {
      new_width = targetWidth;
      new_height = targetWidth / original_aspect_ratio;
    } else {
      // Jika tidak, perlu mengubah skala tinggi
      new_height = targetHeight;
      new_width = targetHeight * original_aspect_ratio;
    }
    print("image.new_width:${new_width} image.new_height:${new_height}");
    return Vector2(new_width, new_height);
  }
}
