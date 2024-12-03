import 'package:hive_flutter/hive_flutter.dart';

class Helpers {
  //!=============================== Constructor ===============================
  static final Helpers _singleton = Helpers._internal();
  factory Helpers() {
    return _singleton;
  }
  Helpers._internal();
  //!===========================================================================

  static Future<void> initApp() async {
    await initHive();
  }

  static Future<void> initHive() async {
    await Hive.initFlutter();
    await Hive.openBox("login");
    await Hive.openBox("accounts");
  }
}
