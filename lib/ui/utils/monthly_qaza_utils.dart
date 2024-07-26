import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qaza_e_umri/models/nimaz.dart';

Future<void> resetMonthlyPrayersCountInDatabase() async {
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  final allNamazRef = FirebaseFirestore.instance
      .collection('history')
      .doc(currentUserUid)
      .collection('allNamaz');

  final querySnapshot = await allNamazRef.get();

  for (var documentSnapshot in querySnapshot.docs) {
    await documentSnapshot.reference.update({
      'Fajar': 0,
      'Zohar': 0,
      'Asar': 0,
      'Maghrib': 0,
      'Isha': 0,
      'Witr': 0,
    });
  }
  TestMonthlyQazaNimazRecord.setNimaz(true, 0, 0, 0, 0, 0, 0);
  print("values are reset");
}
