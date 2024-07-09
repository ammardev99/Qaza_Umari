import 'package:get/get.dart';
import 'package:qaza_e_umri/core/controller/qaza_umri_controller.dart';
import 'package:qaza_e_umri/models/nimaz.dart';

final QazaUmriController loadQazaUmariRecord = Get.put(QazaUmriController());

void SetQazaUmariRecord() {
  TestQazaUmariNimazRecord.setNimaz(
    true,
    loadQazaUmariRecord.fjrTotal.value,
    loadQazaUmariRecord.zhrTotal.value,
    loadQazaUmariRecord.asrTotal.value,
    loadQazaUmariRecord.mgrbTotal.value,
    loadQazaUmariRecord.ishaTotal.value,
    loadQazaUmariRecord.witrTotal.value,
  );
  print("\nQaza Umari Load");
  TestQazaUmariNimazRecord.printNimazValue();
}

void addMonthlyToQazaUmari() {
  TestQazaUmariNimazRecord.addPreviousMonth(
    true,
    TestMonthlyQazaNimazRecord.Fajar,
    TestMonthlyQazaNimazRecord.Zoher,
    TestMonthlyQazaNimazRecord.Asr,
    TestMonthlyQazaNimazRecord.Maghrib,
    TestMonthlyQazaNimazRecord.Isha,
    TestMonthlyQazaNimazRecord.Witer,
  );
  TestMonthlyQazaNimazRecord.setNimaz(false, 0, 0, 0, 0, 0, 0);
}
