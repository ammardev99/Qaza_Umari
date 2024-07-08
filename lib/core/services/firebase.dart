import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qaza_e_umri/constants/app_constants.dart';
import 'package:qaza_e_umri/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

String getDateOfToday() {
  var date = DateTime.now().toString();
  var dateparse = DateTime.parse(date);
  d = dateparse.day;
  m = dateparse.month;
  y = dateparse.year;
  var formattedDate = "${dateparse.day}-${dateparse.month}-${dateparse.year}";
  return formattedDate.toString();
}

Future<void> today() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString('fajarPrayerTime', fajarPrayerTime);
  await preferences.setString('zoharPrayerTime', zoharPrayerTime);
  await preferences.setString('asarPrayerTime', asarPrayerTime);
  await preferences.setString('maghribPrayerTime', maghribPrayerTime);
  await preferences.setString('ishaPrayerTime', ishaPrayerTime);
  await preferences.setString('witrPrayerTime', witrPrayerTime);

  FirebaseAuth auth = FirebaseAuth.instance;
  String? uid = auth.currentUser?.uid.toString();

  DocumentReference collection =
      FirebaseFirestore.instance.collection('namaz').doc(uid);

  collection.set({
    'today': getDateOfToday(),
    'all': "not done",
    'day': d,
    'month': m,
    'year': y
  });

  DocumentReference collections = FirebaseFirestore.instance
      .collection('namaz')
      .doc(uid)
      .collection('today')
      .doc('Fajar');

  collections.set({'name': "Fajar", 'time': fajarPrayerTime, 'status': false});

  DocumentReference collections2 = FirebaseFirestore.instance
      .collection('namaz')
      .doc(uid)
      .collection('today')
      .doc('Zohar');

  collections2.set({'name': "Zohar", 'time': zoharPrayerTime, 'status': false});

  DocumentReference collections3 = FirebaseFirestore.instance
      .collection('namaz')
      .doc(uid)
      .collection('today')
      .doc('Asar');

  collections3.set({'name': "Asar", 'time': asarPrayerTime, 'status': false});

  DocumentReference collections4 = FirebaseFirestore.instance
      .collection('namaz')
      .doc(uid)
      .collection('today')
      .doc('Maghrib');

  collections4
      .set({'name': "Maghrib", 'time': maghribPrayerTime, 'status': false});

  DocumentReference collections5 = FirebaseFirestore.instance
      .collection('namaz')
      .doc(uid)
      .collection('today')
      .doc('Isha');

  collections5.set({'name': "Isha", 'time': ishaPrayerTime, 'status': false});

  DocumentReference collections6 = FirebaseFirestore.instance
      .collection('namaz')
      .doc(uid)
      .collection('today')
      .doc('Witr');

  collections6.set({'name': "Witr", 'time': witrPrayerTime, 'status': false});
}
