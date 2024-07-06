import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class AppLifecycleObserver extends StatefulWidget {
  final Widget child;

  const AppLifecycleObserver({required this.child, super.key});

  @override
  State<AppLifecycleObserver> createState() => _AppLifecycleObserverState();
}

class _AppLifecycleObserverState extends State<AppLifecycleObserver>
    with WidgetsBindingObserver {
  static final _log = Logger('AppLifecycleObserver');

  final ValueNotifier<AppLifecycleState> lifecycleListenable =
      ValueNotifier(AppLifecycleState.inactive);

  @override
  Widget build(BuildContext context) {
    // Menggunakan InheritedProvider karena kita tidak ingin menggunakan Consumer
    // atau context.watch atau apapun seperti itu untuk mendengarkan ini. Kita ingin
    // menambahkan pendengar secara manual. Kita tertarik pada _peristiwa_ perubahan
    // status siklus hidup, dan tidak begitu tertarik pada status itu sendiri. (Misalnya,
    // kita ingin menghentikan suara ketika aplikasi masuk ke latar belakang, dan
    // memulai ulang suara lagi ketika aplikasi kembali ke fokus. Kita tidak
    // membangun ulang widget apapun.)
    //
    // Provider, secara default, akan melempar kesalahan ketika seseorang
    // mencoba menyediakan Listenable (seperti ValueNotifier) tanpa menggunakan
    // sesuatu seperti ValueListenableProvider. InheritedProvider lebih
    // rendah tingkatannya dan tidak memiliki masalah ini.
    return InheritedProvider<ValueNotifier<AppLifecycleState>>.value(
      value: lifecycleListenable,
      child: widget.child,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _log.info(() => 'didChangeAppLifecycleState: $state');
    lifecycleListenable.value = state;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _log.info('Berlangganan ke pembaruan siklus hidup aplikasi');
  }
}
