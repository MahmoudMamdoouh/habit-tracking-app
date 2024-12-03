import 'package:firebase_core/firebase_core.dart';
import 'package:habit_tracking/firebase_options.dart';
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

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static Future<void> initHive() async {
    await Hive.initFlutter();
    await Hive.openBox("login");
    await Hive.openBox("accounts");
  }
}
