import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class TodayQazaController extends GetxController {
  final RxString _fjrTime = "5:00 AM".obs;
  RxString get fjrTime => _fjrTime;

  final RxString _fjrQaza = "4".obs;
  RxString get fjrQaza => _fjrQaza;

  final RxString _fjrMinutes = "30".obs;
  RxString get fjrMinutes => _fjrMinutes;

  final RxString _fjrName = "Fajar".obs;
  RxString get fjrName => _fjrName;

  final RxBool _fjrStatus = false.obs;

  RxBool get fjrStatus => _fjrStatus;

  final RxString _zhrTime = "1:30 PM".obs;
  RxString get zhrTime => _zhrTime;

  final RxString _zhrQaza = "1".obs;
  RxString get zhrQaza => _zhrQaza;

  final RxString _zhrMinutes = "30".obs;
  RxString get zhrMinutes => _zhrMinutes;

  final RxString _zhrName = "Zohar".obs;
  RxString get zhrName => _zhrName;

  final RxBool _zhrStatus = false.obs;

  RxBool get zhrStatus => _zhrStatus;

  final RxString _asrTime = "5:00 PM".obs;
  RxString get asrTime => _asrTime;

  final RxString _asrQaza = "4".obs;
  RxString get asrQaza => _asrQaza;

  final RxString _asrMinutes = "30".obs;
  RxString get asrMinutes => _asrMinutes;

  final RxString _asrName = "Asar".obs;
  RxString get asrName => _asrName;

  final RxBool _asrStatus = false.obs;

  RxBool get asrStatus => _asrStatus;

  final RxString _mgrbTime = "7:00 PM".obs;
  RxString get mgrbTime => _mgrbTime;

  final RxString _mgrbQaza = "6".obs;
  RxString get mgrbQaza => _mgrbQaza;

  final RxString _mgrbMinutes = "30".obs;
  RxString get mgrbMinutes => _mgrbMinutes;

  final RxString _mgrbName = "Maghrib".obs;
  RxString get mgrbName => _mgrbName;

  final RxBool _mgrbStatus = false.obs;

  RxBool get mgrbStatus => _mgrbStatus;

  final RxString _ishaTime = "9:00 PM".obs;
  RxString get ishaTime => _ishaTime;

  final RxString _ishaQaza = "8".obs;
  RxString get ishaQaza => _ishaQaza;

  final RxString _ishaMinutes = "30".obs;
  RxString get ishaMinutes => _ishaMinutes;

  final RxString _ishaName = "Isha".obs;
  RxString get ishaName => _ishaName;

  final RxBool _ishaStatus = false.obs;

  RxBool get ishaStatus => _ishaStatus;

  final RxString _witrTime = "9:10 PM".obs;
  RxString get witrTime => _witrTime;

  final RxString _witrQaza = "9".obs;
  RxString get witrQaza => _witrQaza;

  final RxString _witrMinutes = "40".obs;
  RxString get witrMinutes => _witrMinutes;

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

      _fjrQaza.value = _fjrTime.value[0];
      _fjrMinutes.value = "${_fjrTime.value[2]}${_fjrTime.value[3]}";
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

      _zhrQaza.value = _zhrTime.value[0];
      _zhrMinutes.value = "${_zhrTime.value[2]}${_zhrTime.value[3]}";
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

      _asrQaza.value = _asrTime.value[0];
      _asrMinutes.value = "${_asrTime.value[2]}${_asrTime.value[3]}";
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

      _mgrbQaza.value = _mgrbTime.value[0];
      _mgrbMinutes.value = "${_mgrbTime.value[2]}${_mgrbTime.value[3]}";
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

      _ishaQaza.value = _ishaTime.value[0];
      _ishaMinutes.value = "${_ishaTime.value[2]}${_ishaTime.value[3]}";
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

      _witrQaza.value = _witrTime.value[0];
      _witrMinutes.value = "${_witrTime.value[2]}${_witrTime.value[3]}";
    }).catchError((e) {});
  }
}
