import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class QasarQazaController extends GetxController {
  final RxInt _fjrTotal = 0.obs;
  RxInt get fjrTotal => _fjrTotal;

  final RxString _fjrName = "Fajar".obs;
  RxString get fjrName => _fjrName;

  final RxInt _zhrTotal = 0.obs;
  RxInt get zhrTotal => _zhrTotal;

  final RxString _zhrName = "Zohar".obs;
  RxString get zhrName => _zhrName;

  final RxInt _asrTotal = 0.obs;
  RxInt get asrTotal => _asrTotal;

  final RxString _asrName = "Asar".obs;
  RxString get asrName => _asrName;

  final RxInt _mgrbTotal = 0.obs;
  RxInt get mgrbTotal => _mgrbTotal;

  final RxString _mgrbName = "Maghrib".obs;
  RxString get mgrbName => _mgrbName;

  final RxInt _ishaTotal = 0.obs;
  RxInt get ishaTotal => _ishaTotal;

  final RxString _ishaName = "Isha".obs;
  RxString get ishaName => _ishaName;

  final RxInt _witrTotal = 0.obs;
  RxInt get witrTotal => _witrTotal;

  final RxString _witrName = "Witr".obs;
  RxString get witrName => _witrName;

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
        .collection('qasar')
        .doc('Fajar')
        .get()
        .then((ds) {
      _fjrTotal.value = ds['total'];
      _fjrName.value = ds['name'];
    }).catchError((e) {});
  }

  Future<void> fetchZhr() async {
    final User user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('namaz')
        .doc(user.uid)
        .collection('qasar')
        .doc('Zohar')
        .get()
        .then((ds) {
      _zhrTotal.value = ds['total'];
      _zhrName.value = ds['name'];
    }).catchError((e) {});
  }

  Future<void> fetchAsr() async {
    final User user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('namaz')
        .doc(user.uid)
        .collection('qasar')
        .doc('Asar')
        .get()
        .then((ds) {
      _asrTotal.value = ds['total'];
      _asrName.value = ds['name'];
    }).catchError((e) {});
  }

  Future<void> fetchMgrb() async {
    final User user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('namaz')
        .doc(user.uid)
        .collection('qasar')
        .doc('Maghrib')
        .get()
        .then((ds) {
      _mgrbTotal.value = ds['total'];
      _mgrbName.value = ds['name'];
    }).catchError((e) {});
  }

  Future<void> fetchIsha() async {
    final User user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('namaz')
        .doc(user.uid)
        .collection('qasar')
        .doc('Isha')
        .get()
        .then((ds) {
      _ishaTotal.value = ds['total'];
      _ishaName.value = ds['name'];
    }).catchError((e) {});
  }

  Future<void> fetchWirt() async {
    final User user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('namaz')
        .doc(user.uid)
        .collection('qasar')
        .doc('Witr')
        .get()
        .then((ds) {
      _witrTotal.value = ds['total'];
      _witrName.value = ds['name'];
    }).catchError((e) {});
  }
}
