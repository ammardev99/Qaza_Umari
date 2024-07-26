import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:qaza_e_umri/core/controller/qaza_umri_controller.dart';
import 'package:qaza_e_umri/models/nimaz.dart';

// Instantiate the QazaUmriController
final QazaUmriController loadQazaUmariRecord = Get.put(QazaUmriController());

Future<void> addMonthlyToQazaUmariAndUpdateFirestore() async {
  // Get the current user's UID
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  
  // Reference to the Qaza Umari collection for the current user
  final qazaUmariRef = FirebaseFirestore.instance
      .collection('qazaUmari')
      .doc(currentUserUid);

  // Print monthly values
  print("Monthly Qaza Values:");
  print("Fajar: ${TestMonthlyQazaNimazRecord.Fajar}");
  print("Zohar: ${TestMonthlyQazaNimazRecord.Zoher}");
  print("Asar: ${TestMonthlyQazaNimazRecord.Asr}");
  print("Maghrib: ${TestMonthlyQazaNimazRecord.Maghrib}");
  print("Isha: ${TestMonthlyQazaNimazRecord.Isha}");
  print("Witr: ${TestMonthlyQazaNimazRecord.Witer}");

  // Get the current Qaza Umari data
  DocumentSnapshot snapshot = await qazaUmariRef.get();

  int currentFajar = 0;
  int currentZohar = 0;
  int currentAsar = 0;
  int currentMaghrib = 0;
  int currentIsha = 0;
  int currentWitr = 0;

  if (snapshot.exists) {
    // Retrieve the current values from the database
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    currentFajar = data['Fajar'] ?? 0;
    currentZohar = data['Zohar'] ?? 0;
    currentAsar = data['Asar'] ?? 0;
    currentMaghrib = data['Maghrib'] ?? 0;
    currentIsha = data['Isha'] ?? 0;
    currentWitr = data['Witr'] ?? 0;

    // Print current Qaza Umari values
    print("\nCurrent Qaza Umari Values:");
    print("Fajar: $currentFajar");
    print("Zohar: $currentZohar");
    print("Asar: $currentAsar");
    print("Maghrib: $currentMaghrib");
    print("Isha: $currentIsha");
    print("Witr: $currentWitr");

    // Add the monthly Qaza values to the current values
    currentFajar += TestMonthlyQazaNimazRecord.Fajar;
    currentZohar += TestMonthlyQazaNimazRecord.Zoher;
    currentAsar += TestMonthlyQazaNimazRecord.Asr;
    currentMaghrib += TestMonthlyQazaNimazRecord.Maghrib;
    currentIsha += TestMonthlyQazaNimazRecord.Isha;
    currentWitr += TestMonthlyQazaNimazRecord.Witer;

    // Update the Qaza Umari data in Firestore
    await qazaUmariRef.set({
      'Fajar': currentFajar,
      'Zohar': currentZohar,
      'Asar': currentAsar,
      'Maghrib': currentMaghrib,
      'Isha': currentIsha,
      'Witr': currentWitr,
    });

    // Print updated Qaza Umari values
    print("\nUpdated Qaza Umari Values:");
    print("Fajar: $currentFajar");
    print("Zohar: $currentZohar");
    print("Asar: $currentAsar");
    print("Maghrib: $currentMaghrib");
    print("Isha: $currentIsha");
    print("Witr: $currentWitr");

    // Reset the Monthly Qaza Nimaz record
    TestMonthlyQazaNimazRecord.setNimaz(false, 0, 0, 0, 0, 0, 0);
    print("\nAdded Monthly Qaza to Qaza Umari and updated Firestore");
  } else {
    // If the document does not exist, create it with the monthly Qaza values
    await qazaUmariRef.set({
      'Fajar': TestMonthlyQazaNimazRecord.Fajar,
      'Zohar': TestMonthlyQazaNimazRecord.Zoher,
      'Asar': TestMonthlyQazaNimazRecord.Asr,
      'Maghrib': TestMonthlyQazaNimazRecord.Maghrib,
      'Isha': TestMonthlyQazaNimazRecord.Isha,
      'Witr': TestMonthlyQazaNimazRecord.Witer,
    });

    // Print updated Qaza Umari values
    print("\nCreated new Qaza Umari record and added Monthly Qaza to Firestore");
    print("Fajar: ${TestMonthlyQazaNimazRecord.Fajar}");
    print("Zohar: ${TestMonthlyQazaNimazRecord.Zoher}");
    print("Asar: ${TestMonthlyQazaNimazRecord.Asr}");
    print("Maghrib: ${TestMonthlyQazaNimazRecord.Maghrib}");
    print("Isha: ${TestMonthlyQazaNimazRecord.Isha}");
    print("Witr: ${TestMonthlyQazaNimazRecord.Witer}");

    // Reset the Monthly Qaza Nimaz record
    TestMonthlyQazaNimazRecord.setNimaz(false, 0, 0, 0, 0, 0, 0);
    print("\nAdded Monthly Qaza to Qaza Umari and reset Monthly Qaza");
  }
}
