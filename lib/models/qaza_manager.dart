// qaza_manager.dart

import 'package:qaza_e_umri/models/nimaz.dart';

class QazaManager {
  // Singleton pattern
  static final QazaManager _instance = QazaManager._internal();

  factory QazaManager() {
    return _instance;
  }

  QazaManager._internal();

  int fajar = 0;
  int zohar = 0;
  int asar = 0;
  int maghrib = 0;
  int isha = 0;
  int witr = 0;

  void resetMonthlyPrayersCount() {
    fajar = 0;
    zohar = 0;
    asar = 0;
    maghrib = 0;
    isha = 0;
    witr = 0;

    TestMonthlyQazaNimazRecord.setNimaz(true, fajar, zohar, asar, maghrib, isha, witr);
    TestMonthlyQazaNimazRecord.printNimazValue();
  }
}
