import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qaza_e_umri/ui/screens/monthly_qaza/monthly_qaza.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final searchController = TextEditingController();
  //final uid = FirebaseAuth.instance.currentUser!.uid;
  List _allResult = [];
  List _resultList = [];

  searchResult() {
    var searchData = [];
    if (searchController.text != "") {
      for (var clientSnapShot in _allResult) {
        var date = clientSnapShot['date'].toString();
        if (date.contains(searchController.text)) {
          searchData.add(clientSnapShot);
        }
      }
    } else {
      searchData = List.from(_allResult);
    }

    setState(() {
      _resultList = searchData;
    });
  }

  getDataResult() async {
    var data = await FirebaseFirestore.instance
        .collection('history')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('allNamaz')
        .get();

    setState(() {
      _allResult = data.docs;
    });
    searchResult();
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChange);
    searchController.dispose();
    super.dispose();
  }

  final CollectionReference historyStream = FirebaseFirestore.instance
      .collection('history')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('allNamaz');

  final CollectionReference qazaiUmreNamaz = FirebaseFirestore.instance
      .collection('namaz')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('umri');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    searchController.addListener(_onSearchChange);
  }

  // function _onSearchChange

  _onSearchChange() {
    searchResult();
  }

  @override
  void didChangeDependencies() {
    getDataResult();
    super.didChangeDependencies();
  }

  String getDateOfToday() {
    var date = DateTime.now().toString();
    var dateparse = DateTime.parse(date);
    var formattedDate = "${dateparse.day}-${dateparse.month}-${dateparse.year}";
    return formattedDate.toString();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final w = MediaQuery.sizeOf(context).width;
    FirebaseAuth auth = FirebaseAuth.instance;
    String? uid = auth.currentUser?.uid.toString();
    String formattedDate =
        "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
    final fajarNamaz = qazaiUmreNamaz.doc("Fajar");
    final zoharNamaz = qazaiUmreNamaz.doc("Zohar");
    final asrNamaz = qazaiUmreNamaz.doc("Asar");
    final maghribNamaz = qazaiUmreNamaz.doc("Maghrib");
    final ishaNamaz = qazaiUmreNamaz.doc("Isha");

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.history),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => MonthlyQaza()));
              },
              icon: Icon(Icons.history))
        ],
      ),
      body: Container(
        width: w,
        height: h * 0.7,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                left: 5,
                right: 5,
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  //border: OutlineInputBorder(),
                  hintText: AppLocalizations.of(context)!.search,
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            // StreamBuilder
            Container(
              height: h * 0.58,
              child: StreamBuilder<QuerySnapshot>(
                stream: historyStream.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                            AppLocalizations.of(context)!.someThingWentWrong));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                        child: Text(AppLocalizations.of(context)!.noDataFound));
                  }
                  return ListView.builder(
                    // reverse: true,
                    itemCount: _resultList.length,
                    //  itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final data = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;

                      int fazar = _resultList[index]['Fajar'];
                      int zoher = _resultList[index]['Zohar'];
                      int asar = _resultList[index]['Asar'];
                      int maghrib = _resultList[index]['Maghrib'];
                      int isha = _resultList[index]['Isha'];
                      bool fz = fazar == 0 ? true : false;
                      bool zh = zoher == 0 ? true : false;
                      bool as = asar == 0 ? true : false;
                      bool mgb = maghrib == 0 ? true : false;
                      bool ish = isha == 0 ? true : false;
                      String dateIs = _resultList[index]['date'];
                      return formattedDate == dateIs
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10, bottom: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(_resultList[index]['date'],
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red)),
                                  ),
                                  !fz
                                      ? ListTile(
                                          title: Text(
                                            AppLocalizations.of(context)!.fajar,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          trailing: Checkbox(
                                              checkColor: Colors.white,
                                              activeColor: Colors.green,
                                              value: fz,
                                              onChanged: (v) {
                                                print(
                                                    "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<The Button is Pressed");
                                                DocumentReference collection6 =
                                                    FirebaseFirestore.instance
                                                        .collection("history")
                                                        .doc(uid)
                                                        .collection('allNamaz')
                                                        .doc(dateIs);
                                                collection6.update({
                                                  // 'name': widget.nameOfTheNamaz,
                                                  // 'time': widget.timeOfTheNamaz,
                                                  // widget.nameOfTheNamaz : 1,
                                                  'Fajar': 0,
                                                  // 'Zohar':1,
                                                  // 'Asar':1,
                                                  // 'Maghrib':1,
                                                  // 'Isha':1,
                                                }).then((value) {
                                                  // fajarNamaz.update({
                                                  //   "total": 1,
                                                  // });
                                                  setState(() {
                                                    fz = true;
                                                  });
                                                });
                                              }),
                                        )
                                      : Container(),
                                  !zh
                                      ? ListTile(
                                          title: Text(
                                            AppLocalizations.of(context)!.zohar,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          trailing: Checkbox(
                                              checkColor: Colors.white,
                                              activeColor: Colors.green,
                                              value: zh,
                                              onChanged: (v) {
                                                DocumentReference collection6 =
                                                    FirebaseFirestore.instance
                                                        .collection("history")
                                                        .doc(uid)
                                                        .collection('allNamaz')
                                                        .doc(dateIs);
                                                collection6.update({
                                                  // 'name': widget.nameOfTheNamaz,
                                                  // 'time': widget.timeOfTheNamaz,
                                                  // widget.nameOfTheNamaz : 1,
                                                  // 'Fajar':0,

                                                  'Zohar': 0,
                                                  // 'Asar':1,
                                                  // 'Maghrib':1,
                                                  // 'Isha':1,
                                                }).then((value) {
                                                  setState(() {
                                                    zh = true;
                                                  });
                                                });
                                              }),
                                        )
                                      : Container(),
                                  !as
                                      ? ListTile(
                                          title: Text(
                                            AppLocalizations.of(context)!.asar,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          trailing: Checkbox(
                                              checkColor: Colors.white,
                                              activeColor: Colors.green,
                                              value: as,
                                              onChanged: (v) {
                                                DocumentReference collection6 =
                                                    FirebaseFirestore.instance
                                                        .collection("history")
                                                        .doc(uid)
                                                        .collection('allNamaz')
                                                        .doc(dateIs);
                                                collection6.update({
                                                  // 'name': widget.nameOfTheNamaz,
                                                  // 'time': widget.timeOfTheNamaz,
                                                  // widget.nameOfTheNamaz : 1,
                                                  // 'Fajar':0,

                                                  // 'Zohar':1,
                                                  'Asar': 0,
                                                  // 'Maghrib':1,
                                                  // 'Isha':1,
                                                }).then((value) {
                                                  setState(() {
                                                    as = true;
                                                  });
                                                });
                                              }),
                                        )
                                      : Container(),
                                  !mgb
                                      ? ListTile(
                                          title: Text(
                                            AppLocalizations.of(context)!
                                                .maghrib,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          trailing: Checkbox(
                                              checkColor: Colors.white,
                                              activeColor: Colors.green,
                                              value: mgb,
                                              onChanged: (v) {
                                                DocumentReference collection6 =
                                                    FirebaseFirestore.instance
                                                        .collection("history")
                                                        .doc(uid)
                                                        .collection('allNamaz')
                                                        .doc(dateIs);
                                                collection6.update({
                                                  // 'name': widget.nameOfTheNamaz,
                                                  // 'time': widget.timeOfTheNamaz,
                                                  // widget.nameOfTheNamaz : 1,
                                                  // 'Fajar':0,

                                                  // 'Zohar':1,
                                                  // 'Asar':1,
                                                  'Maghrib': 0,
                                                  // 'Isha':1,
                                                }).then((value) {
                                                  setState(() {
                                                    mgb = true;
                                                  });
                                                });
                                              }),
                                        )
                                      : Container(),
                                  !ish
                                      ? ListTile(
                                          title: Text(
                                            AppLocalizations.of(context)!.isha,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          trailing: Checkbox(
                                              checkColor: Colors.white,
                                              activeColor: Colors.green,
                                              value: ish,
                                              onChanged: (v) {
                                                DocumentReference collection6 =
                                                    FirebaseFirestore.instance
                                                        .collection("history")
                                                        .doc(uid)
                                                        .collection('allNamaz')
                                                        .doc(dateIs);
                                                collection6.update({
                                                  // 'name': widget.nameOfTheNamaz,
                                                  // 'time': widget.timeOfTheNamaz,
                                                  // widget.nameOfTheNamaz : 1,
                                                  // 'Fajar':0,

                                                  // 'Zohar':1,
                                                  // 'Asar':1,
                                                  // 'Maghrib':1,
                                                  'Isha': 0,
                                                }).then((value) {
                                                  setState(() {
                                                    ish = true;
                                                  });
                                                });
                                              }),
                                        )
                                      : Container(),
                                  ListTile(
                                    title: Text(
                                      AppLocalizations.of(context)!.witr,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: Checkbox(
                                        checkColor: Colors.white,
                                        activeColor: Colors.green,
                                        value: ish,
                                        onChanged: (v) {
                                          DocumentReference collection6 =
                                              FirebaseFirestore.instance
                                                  .collection("history")
                                                  .doc(uid)
                                                  .collection('allNamaz')
                                                  .doc(dateIs);
                                          collection6.update({
                                            // 'name': widget.nameOfTheNamaz,
                                            // 'time': widget.timeOfTheNamaz,
                                            // widget.nameOfTheNamaz : 1,
                                            // 'Fajar':0,

                                            // 'Zohar':1,
                                            // 'Asar':1,
                                            // 'Maghrib':1,
                                            'Isha': 0,
                                          }).then((value) {
                                            setState(() {
                                              ish = true;
                                            });
                                          });
                                        }),
                                  ),
                                  Divider(
                                    thickness: 4,
                                  )
                                ],
                              ),
                            );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
