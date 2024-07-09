import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qaza_e_umri/models/nimaz.dart';

Future<Map<String, int>> countPrayersCurrentUser() async {
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('history')
      .doc(currentUserUid)
      .collection('allNamaz')
      .get();

  Map<String, int> prayersCount = {
    'Fajar': 0,
    'Zohar': 0,
    'Asar': 0,
    'Maghrib': 0,
    'Isha': 0,
    'Witr': 0,
  };

  querySnapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      // Extract data from the document
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      // Loop through the prayer fields and count the ones equal to 1
      prayersCount.forEach((prayer, _) {
        if (data.containsKey(prayer) && data[prayer] == 1) {
          prayersCount[prayer] = (prayersCount[prayer] ?? 0) + 1;
        }
      });
    }
  });

  return prayersCount;
}

Map<String, int> _MonthlyQazaPrayersCount = {};

Future<void> loadMonthlyQazaRecord() async {
  Map<String, int> prayersCount = await countPrayersCurrentUser();
  _MonthlyQazaPrayersCount = prayersCount;
  TestMonthlyQazaNimazRecord.setNimaz(
    true,
    prayersCount['Fajar']!.toInt(),
    prayersCount['Zohar']!.toInt(),
    prayersCount['Asar']!.toInt(),
    prayersCount['Maghrib']!.toInt(),
    prayersCount['Isha']!.toInt(),
    prayersCount['Witr']!.toInt(),
  );
}




                  // IconButton(
                  //   onPressed: () {
                  //     setState(() {
                  //       MonthlyQazaNimazRecord.NimazData == true
                  //           ? addMonthlyQaza()
                  //           : '';
                  //     });
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       SnackBar(
                  //         backgroundColor: Colors.green,
                  //         content: MonthlyQazaNimazRecord.NimazData == true
                  //             ? Text("Add Recorde Update")
                  //             : Text("1st Open Monthly Qaza"),
                  //       ),
                  //     );
                  //     MonthlyQazaNimazRecord.printNimazValue();
                  //   },
                  //   icon: Icon(
                  //     Icons.nearby_error,
                  //     color: Colors.red,
                  //   ),
                  // ),
