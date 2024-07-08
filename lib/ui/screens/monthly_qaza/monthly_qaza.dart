import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qaza_e_umri/models/nimaz.dart';
import 'package:qaza_e_umri/ui/screens/homepage/nav_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MonthlyQaza extends StatefulWidget {
  const MonthlyQaza({super.key});

  @override
  State<MonthlyQaza> createState() => _MonthlyQazaState();
}

class _MonthlyQazaState extends State<MonthlyQaza> {
  int fajar = 0;
  int asar = 0;
  int zohar = 0;
  int maghrib = 0;
  int isha = 0;
  int witr = 0;

  Future<Map<String, int>> countPrayersEqualToOneForCurrentUser() async {
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

  Map<String, int> _prayersCount = {};

  @override
  void initState() {
    super.initState();
    _loadPrayersCount();
  }

void _loadPrayersCount() async {
  Map<String, int> prayersCount = await countPrayersEqualToOneForCurrentUser();
  setState(() {
    _prayersCount = prayersCount;
    fajar = prayersCount['Fajar']!.toInt();
    zohar = prayersCount['Zohar']!.toInt();
    asar = prayersCount['Asar']!.toInt();
    maghrib = prayersCount['Maghrib']!.toInt();
    isha = prayersCount['Isha']!.toInt();
    witr = prayersCount['Witr']!.toInt();
  });
  MonthlyQazaNimazRecord.setNimaz(true, fajar, zohar, asar, maghrib, isha, witr);
  MonthlyQazaNimazRecord.printNimazValue();
}


void _MonthResetPrayersCount() async {
  setState(() {
    // Set all the prayer counts to zero
    fajar = 0;
    zohar = 0;
    asar = 0;
    maghrib = 0;
    isha = 0;
    witr = 0;

    // Update the _prayersCount map to zero values
    _prayersCount = {
      'Fajar': fajar,
      'Zohar': zohar,
      'Asar': asar,
      'Maghrib': maghrib,
      'Isha': isha,
      'Witr': witr,
    };

    // Set the Nimaz values to zero
    MonthlyQazaNimazRecord.setNimaz(true, fajar, zohar, asar, maghrib, isha, witr);
    MonthlyQazaNimazRecord.printNimazValue();
  });
}



  @override
  Widget build(BuildContext context) {
    print('ccccccccccccccccccccccc');
    print(fajar);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.monthlyQaza),
        leading: IconButton(
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const NavBar();
                })),
            icon: Icon(Icons.arrow_back)),
      ),
      body: _prayersCount.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: _prayersCount.keys.map((String prayer) {
                return ListTile(
                  title: Text(
                    '${AppLocalizations.of(context)!.total} $prayer ${AppLocalizations.of(context)!.qaza}',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  trailing: Text(
                    '${_prayersCount[prayer]}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
