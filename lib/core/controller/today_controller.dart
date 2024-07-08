import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:qaza_e_umri/constants/app_constants.dart';

class TodayController extends GetxController {
  final RxString _fjrTime = fajarPrayerTime.obs;
  RxString get fjrTime => _fjrTime;

  final RxString _fjrName = "Fajar".obs;
  RxString get fjrName => _fjrName;

  final RxBool _fjrStatus = false.obs;

  RxBool get fjrStatus => _fjrStatus;

  final RxString _zhrTime = zoharPrayerTime.obs;
  RxString get zhrTime => _zhrTime;

  final RxString _zhrName = "Zohar".obs;
  RxString get zhrName => _zhrName;

  final RxBool _zhrStatus = false.obs;

  RxBool get zhrStatus => _zhrStatus;

  final RxString _asrTime = asarPrayerTime.obs;
  RxString get asrTime => _asrTime;

  final RxString _asrName = "Asar".obs;
  RxString get asrName => _asrName;

  final RxBool _asrStatus = false.obs;

  RxBool get asrStatus => _asrStatus;

  final RxString _mgrbTime = maghribPrayerTime.obs;
  RxString get mgrbTime => _mgrbTime;

  final RxString _mgrbName = "Maghrib".obs;
  RxString get mgrbName => _mgrbName;

  final RxBool _mgrbStatus = false.obs;

  RxBool get mgrbStatus => _mgrbStatus;

  final RxString _ishaTime = ishaPrayerTime.obs;
  RxString get ishaTime => _ishaTime;

  final RxString _ishaName = "Isha".obs;
  RxString get ishaName => _ishaName;

  final RxBool _ishaStatus = false.obs;

  RxBool get ishaStatus => _ishaStatus;

  final RxString _witrTime = witrPrayerTime.obs;
  RxString get witrTime => _witrTime;

  final RxString _witrName = "Witr".obs;
  RxString get witrName => _witrName;

  final RxBool _witrStatus = false.obs;

  RxBool get witrStatus => _witrStatus;

  @override
  void onInit() {
    fetchFjr();
    fetchZhr();
    fetchAsr();
    fetchMgrb();
    fetchIsha();
    fetchWirt();
    super.onInit();
  }

  Future<void> fetchFjr() async {
    final User user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('namaz')
        .doc(user.uid)
        .collection('today')
        .doc('Fajar')
        .get()
        .then((ds) {
      _fjrTime.value = ds['time'];
      _fjrName.value = ds['name'];
      _fjrStatus.value = ds['status'];
    }).catchError((e) {});
  }

  Future<void> fetchZhr() async {
    final User user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('namaz')
        .doc(user.uid)
        .collection('today')
        .doc('Zohar')
        .get()
        .then((ds) {
      _zhrTime.value = ds['time'];
      _zhrName.value = ds['name'];
      _zhrStatus.value = ds['status'];
    }).catchError((e) {});
  }

  Future<void> fetchAsr() async {
    final User user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('namaz')
        .doc(user.uid)
        .collection('today')
        .doc('Asar')
        .get()
        .then((ds) {
      _asrTime.value = ds['time'];
      _asrName.value = ds['name'];
      _asrStatus.value = ds['status'];
    }).catchError((e) {});
  }

  Future<void> fetchMgrb() async {
    final User user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('namaz')
        .doc(user.uid)
        .collection('today')
        .doc('Maghrib')
        .get()
        .then((ds) {
      _mgrbTime.value = ds['time'];
      _mgrbName.value = ds['name'];
      _mgrbStatus.value = ds['status'];
    }).catchError((e) {});
  }

  Future<void> fetchIsha() async {
    final User user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('namaz')
        .doc(user.uid)
        .collection('today')
        .doc('Isha')
        .get()
        .then((ds) {
      _ishaTime.value = ds['time'];
      _ishaName.value = ds['name'];
      _ishaStatus.value = ds['status'];
    }).catchError((e) {});
  }

  Future<void> fetchWirt() async {
    final User user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('namaz')
        .doc(user.uid)
        .collection('today')
        .doc('Witr')
        .get()
        .then((ds) {
      _witrTime.value = ds['time'];
      _witrName.value = ds['name'];
      _witrStatus.value = ds['status'];
    }).catchError((e) {});
  }
}
