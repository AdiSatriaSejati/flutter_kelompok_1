import 'package:flutter/foundation.dart';

/// Mengenkapsulasi skor dan aritmatika untuk menghitungnya.
@immutable
class Score {
  final Duration duration;

  const Score(this.duration);

  /// Mengembalikan waktu yang diformat sebagai string.
  String get formattedTime {
    final buf = StringBuffer();
    if (duration.inHours > 0) {
      buf.write('${duration.inHours}');
      buf.write(':');
    }
    final minutes = duration.inMinutes % Duration.minutesPerHour;
    if (minutes > 9) {
      buf.write('$minutes');
    } else {
      buf.write('0');
      buf.write('$minutes');
    }
    buf.write(':');
    buf.write((duration.inSeconds % Duration.secondsPerMinute)
        .toString()
        .padLeft(2, '0'));
    return buf.toString();
  }
}
