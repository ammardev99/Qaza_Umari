import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:qaza_e_umri/core/controller/qaza_umri_controller.dart';
import 'package:qaza_e_umri/main.dart';
import 'package:qaza_e_umri/constants/assets_path.dart';
import 'package:qaza_e_umri/ui/widgets/reusable_qaza_umri.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/app_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QazaUmri extends StatefulWidget {
  const QazaUmri({super.key});

  @override
  State<QazaUmri> createState() => _QazaUmriState();
}

class _QazaUmriState extends State<QazaUmri> {
  List<int> pubertyYears = [
    2008,
    2009,
    2010,
    2011,
    2012,
    2013,
    2014,
    2015,
    2016,
    2017,
  ];
  int selectedYear = 2010;

  List<int> avgMens = [2, 3, 4, 5, 6, 7, 8, 9, 10];
  int selectedAvgMens = 3;

  String gender = '';
  String children = '';
  int total = 0;
  int birthYear = 0;
  String today = '';
  String all = '';
  final QazaUmriController _qazaumriController = Get.put(QazaUmriController());
  bool isToday = false;

  String pubertyController = "";
  String mensController = "";

  TextEditingController childrenController = TextEditingController();

  TextEditingController fjrController = TextEditingController();
  TextEditingController zhrController = TextEditingController();
  TextEditingController asrController = TextEditingController();
  TextEditingController mgrbController = TextEditingController();
  TextEditingController ishaController = TextEditingController();
  TextEditingController witrController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Gap(2.h),

            /// today
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!.qazaUmriRecord,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      // Gap(.4.h),
                      // Text(getDateOfToday()),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      infoDialog();
                    },
                    child: const Icon(
                      mInfoIcon,
                      color: colorsGreen,
                    ),
                  ),
                ],
              ),
            ),

            /// namaz and days
            Obx(
              () => ReusableQazaUmri(
                nameOfTheNamaz: AppLocalizations.of(context)!.fajar,
                totalNamaz: _qazaumriController.fjrTotal.value,
              ),
            ),
            Obx(
              () => ReusableQazaUmri(
                nameOfTheNamaz: AppLocalizations.of(context)!.zohar,
                totalNamaz: _qazaumriController.zhrTotal.value,
              ),
            ),
            Obx(
              () => ReusableQazaUmri(
                nameOfTheNamaz: AppLocalizations.of(context)!.asar,
                totalNamaz: _qazaumriController.asrTotal.value,
              ),
            ),
            Obx(
              () => ReusableQazaUmri(
                nameOfTheNamaz: AppLocalizations.of(context)!.maghrib,
                totalNamaz: _qazaumriController.mgrbTotal.value,
              ),
            ),
            Obx(() => ReusableQazaUmri(
                  nameOfTheNamaz: AppLocalizations.of(context)!.isha,
                  totalNamaz: _qazaumriController.ishaTotal.value,
                )),
            Obx(() => ReusableQazaUmri(
                  nameOfTheNamaz: AppLocalizations.of(context)!.witr,
                  totalNamaz: _qazaumriController.witrTotal.value,
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_qazaumriController.fjrTotal.value > 0 ||
              _qazaumriController.zhrTotal.value > 0 ||
              _qazaumriController.asrTotal.value > 0 ||
              _qazaumriController.mgrbTotal.value > 0 ||
              _qazaumriController.ishaTotal.value > 0 ||
              _qazaumriController.witrTotal.value > 0) {
            confirmDialog();
          } else {
            openDialog();
          }
        },
        label: Text(AppLocalizations.of(context)!.calculator),
        icon: const Icon(Icons.calculate),
        backgroundColor: colorsGreen,
      ),
    );
  }

  Future<void> saveUmri() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String? uid = auth.currentUser?.uid.toString();

    total = total - (int.parse(pubertyController) - birthYear) * 365;

    if (gender == "female") {
      total = total -
          (((y - int.parse(pubertyController)) * 12) *
              (int.parse(mensController))) +
          (int.parse(childrenController.text) * 9 * int.parse(mensController)) -
          (int.parse(childrenController.text) * 40);
    }

    double fjr = total - (total * int.parse(fjrController.text) / 100);
    double zhr = total - (total * int.parse(zhrController.text) / 100);
    double asr = total - (total * int.parse(asrController.text) / 100);
    double mgrb = total - (total * int.parse(mgrbController.text) / 100);
    double isha = total - (total * int.parse(ishaController.text) / 100);
    double witr = total - (total * int.parse(witrController.text) / 100);

    _qazaumriController.fjrTotal.value = fjr.toInt();
    _qazaumriController.zhrTotal.value = zhr.toInt();
    _qazaumriController.asrTotal.value = asr.toInt();
    _qazaumriController.mgrbTotal.value = mgrb.toInt();
    _qazaumriController.ishaTotal.value = isha.toInt();
    _qazaumriController.witrTotal.value = witr.toInt();

    total = 0;

    DocumentReference collections = FirebaseFirestore.instance
        .collection('namaz')
        .doc(uid)
        .collection('umri')
        .doc('Fajar');

    collections
        .set({'name': "Fajar", 'total': _qazaumriController.fjrTotal.value});

    DocumentReference collections2 = FirebaseFirestore.instance
        .collection('namaz')
        .doc(uid)
        .collection('umri')
        .doc('Zohar');

    collections2
        .set({'name': "Zohar", 'total': _qazaumriController.zhrTotal.value});

    DocumentReference collections3 = FirebaseFirestore.instance
        .collection('namaz')
        .doc(uid)
        .collection('umri')
        .doc('Asar');

    collections3
        .set({'name': "Asar", 'total': _qazaumriController.asrTotal.value});

    DocumentReference collections4 = FirebaseFirestore.instance
        .collection('namaz')
        .doc(uid)
        .collection('umri')
        .doc('Maghrib');

    collections4
        .set({'name': "Maghrib", 'total': _qazaumriController.mgrbTotal.value});

    DocumentReference collections5 = FirebaseFirestore.instance
        .collection('namaz')
        .doc(uid)
        .collection('umri')
        .doc('Isha');

    collections5
        .set({'name': "Isha", 'total': _qazaumriController.ishaTotal.value});

    DocumentReference collections6 = FirebaseFirestore.instance
        .collection('namaz')
        .doc(uid)
        .collection('umri')
        .doc('Witr');

    collections6
        .set({'name': "Witr", 'total': _qazaumriController.witrTotal.value});
  }

  void openDialog() {
    showDialog(
        context: context,
        builder: (ctx) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: colorsGreen,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                AppLocalizations.of(context)!.umriCalculator,
              ),
              actions: [
                InkWell(
                  onTap: () {
                    mInfo();
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(
                      mInfoIcon,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            body: StatefulBuilder(builder: (context, setState) {
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.man),
                          Text(
                            AppLocalizations.of(context)!.gender,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile(
                              activeColor: colorsGreen,
                              //controlAffinity: ListTileControlAffinity.trailing,
                              title: Text(AppLocalizations.of(context)!.male),
                              value: "male",
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value.toString();
                                  //print(gender);
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              activeColor: colorsGreen,
                              //controlAffinity: ListTileControlAffinity.trailing,
                              title: Text(AppLocalizations.of(context)!.female),
                              value: "female",
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value.toString();
                                  //print(gender);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(Icons.calendar_view_day),
                          Text(
                            AppLocalizations.of(context)!.dateOfBirth,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          //dateOrder: DatePickerDateOrder.dmy,
                          initialDateTime: DateTime(2000, 1, 1),
                          onDateTimeChanged: (DateTime newDateTime) {
                            setState(() {
                              birthYear = newDateTime.year;
                              int day = d - newDateTime.day;
                              int month = (m - newDateTime.month) * 30;
                              int year = (y - newDateTime.year) * 365;

                              total = (day + month + year);
                              pubertyYears = [
                                birthYear + 8,
                                birthYear + 9,
                                birthYear + 10,
                                birthYear + 11,
                                birthYear + 12,
                                birthYear + 13,
                                birthYear + 14,
                                birthYear + 15,
                                birthYear + 16,
                                birthYear + 17,
                              ];
                              selectedYear = birthYear + 10;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.calendar_month),
                          Text(AppLocalizations.of(context)!.yearOfPuberty,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          const Spacer(),
                          SizedBox(
                            width: 100.0,
                            child: DropdownButton(
                              isExpanded: true,
                              hint: Text(AppLocalizations.of(context)!
                                  .balooghat), // Not necessary for Option 1
                              value: selectedYear > birthYear
                                  ? selectedYear
                                  : null,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedYear = newValue!;
                                  pubertyController = selectedYear.toString();
                                  //print(pubertyController);
                                });
                              },
                              items: pubertyYears.map((location) {
                                return DropdownMenuItem(
                                  value: location,
                                  child: Text('$location'),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      gender == "female"
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.loop),
                                      Text(
                                          AppLocalizations.of(context)!
                                              .woMenCycleDay,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      const Spacer(),
                                      SizedBox(
                                        width: 100,
                                        child: DropdownButton(
                                          isExpanded: true,
                                          hint: const Text(
                                              '3'), // Not necessary for Option 1
                                          value: selectedAvgMens,
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedAvgMens = newValue!;
                                              mensController =
                                                  selectedAvgMens.toString();
                                            });
                                          },
                                          items: avgMens.map((days) {
                                            return DropdownMenuItem(
                                              value: days,
                                              child: Text('$days'),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.bedroom_baby),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .haveAnyChildren,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: RadioListTile(
                                          activeColor: colorsGreen,
                                          // controlAffinity:
                                          //     ListTileControlAffinity.trailing,
                                          title: Text(
                                              AppLocalizations.of(context)!
                                                  .yes),
                                          value: "yes",
                                          groupValue: children,
                                          onChanged: (value) {
                                            setState(() {
                                              children = value.toString();
                                            });
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: RadioListTile(
                                          activeColor: Colors.blueAccent,
                                          // controlAffinity:
                                          //     ListTileControlAffinity.trailing,
                                          title: Text(
                                              AppLocalizations.of(context)!.no),
                                          value: "no",
                                          groupValue: children,
                                          onChanged: (value) {
                                            setState(() {
                                              children = value.toString();
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  )
                                ])
                          : Container(),
                      children == "yes" && gender == "female"
                          ? Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: TextField(
                                    controller: childrenController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colorsGreen),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colorsGreen),
                                      ),
                                      //border: OutlineInputBorder(),
                                      hintText: AppLocalizations.of(context)!
                                          .howManyChildrenYouHave,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                )
                              ],
                            )
                          : Container(),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(Icons.done),
                          Text(
                            AppLocalizations.of(context)!.namazOffered,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                Flexible(
                                  child: TextField(
                                    controller: fjrController,
                                    keyboardType: TextInputType.number,
                                    cursorColor: colorsGreen,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colorsGreen),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colorsGreen),
                                      ),
                                      //border: OutlineInputBorder(),
                                      hintText:
                                          AppLocalizations.of(context)!.fajar,
                                      hintStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  "%",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: colorsGreen),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                Flexible(
                                  child: TextField(
                                    controller: zhrController,
                                    keyboardType: TextInputType.number,
                                    cursorColor: colorsGreen,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colorsGreen),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colorsGreen),
                                      ),
                                      //border: OutlineInputBorder(),
                                      hintText:
                                          AppLocalizations.of(context)!.zohar,
                                      hintStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  "%",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: colorsGreen),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                Flexible(
                                  child: TextField(
                                    controller: asrController,
                                    keyboardType: TextInputType.number,
                                    cursorColor: colorsGreen,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colorsGreen),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colorsGreen),
                                      ),
                                      //border: OutlineInputBorder(),
                                      hintText:
                                          AppLocalizations.of(context)!.asar,
                                      hintStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  "%",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: colorsGreen),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                Flexible(
                                  child: TextField(
                                    controller: mgrbController,
                                    keyboardType: TextInputType.number,
                                    cursorColor: colorsGreen,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colorsGreen),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colorsGreen),
                                      ),
                                      //border: OutlineInputBorder(),
                                      hintText:
                                          AppLocalizations.of(context)!.maghrib,
                                      hintStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  "%",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: colorsGreen),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Flexible(
                                    child: TextField(
                                      controller: ishaController,
                                      keyboardType: TextInputType.number,
                                      cursorColor: colorsGreen,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorsGreen),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorsGreen),
                                        ),
                                        //border: OutlineInputBorder(),
                                        hintText:
                                            AppLocalizations.of(context)!.isha,
                                        hintStyle: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    "%",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: colorsGreen),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                ],
                              )),
                          Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Flexible(
                                    child: TextField(
                                      controller: witrController,
                                      keyboardType: TextInputType.number,
                                      cursorColor: colorsGreen,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorsGreen),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colorsGreen),
                                        ),
                                        //border: OutlineInputBorder(),
                                        hintText:
                                            AppLocalizations.of(context)!.witr,
                                        hintStyle: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    "%",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: colorsGreen),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 40,
                                  //margin: EdgeInsets.symmetric(horizontal: 40),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: colorsGreen),
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.cancel,
                                      style: TextStyle(
                                          color: colorsGreen,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.of(ctx).pop();
                              },
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                if (pubertyController.isNotEmpty &&
                                    fjrController.text.isNotEmpty &&
                                    zhrController.text.isNotEmpty &&
                                    asrController.text.isNotEmpty &&
                                    mgrbController.text.isNotEmpty &&
                                    ishaController.text.isNotEmpty &&
                                    witrController.text.isNotEmpty &&
                                    int.parse(fjrController.text) < 100 &&
                                    int.parse(fjrController.text) > -1 &&
                                    int.parse(zhrController.text) < 100 &&
                                    int.parse(zhrController.text) > -1 &&
                                    int.parse(asrController.text) < 100 &&
                                    int.parse(asrController.text) > -1 &&
                                    int.parse(mgrbController.text) < 100 &&
                                    int.parse(mgrbController.text) > -1 &&
                                    int.parse(ishaController.text) < 100 &&
                                    int.parse(ishaController.text) > -1 &&
                                    int.parse(witrController.text) < 100 &&
                                    int.parse(witrController.text) > -1) {
                                  Future.delayed(
                                          const Duration(microseconds: 1))
                                      .then((value) {
                                    snackShow();
                                  });
                                  saveUmri();
                                  Navigator.of(ctx).pop();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(AppLocalizations.of(
                                                  context)!
                                              .fillUpAllTheFieldsCorrectly)));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 40,
                                  //margin: EdgeInsets.symmetric(horizontal: 40),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: colorsGreen),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.calculate,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }

  void infoDialog() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.learnAboutQazaUmri,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF000000)),
            ),
            content: Text(
              '${AppLocalizations.of(context)!.thisIsQazaUmriRecord}\n\n${AppLocalizations.of(context)!.toCalculateYourQazaUmriTillDatePleasePress}\n\n${AppLocalizations.of(context)!.ifYouHaveCalculatedAlreadyStartOffering}\n\n${AppLocalizations.of(context)!.forMoreInformation}',
            ),
            actions: [
              Row(
                children: [
                  Expanded(child: Container()),
                  Expanded(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          //margin: EdgeInsets.symmetric(horizontal: 40),
                          decoration: BoxDecoration(
                              //border: Border.all(color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(5),
                              color: colorsGreen),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.ok,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  void confirmDialog() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.doYouWantToRecalculate,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF000000)),
            ),
            content: Text(
              AppLocalizations.of(context)!
                  .yourPreviousDataWillBeLostAndTheProcessIsIrrevocable,
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          //margin: EdgeInsets.symmetric(horizontal: 40),
                          decoration: BoxDecoration(
                              border: Border.all(color: colorsGreen),
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.no,
                              style: TextStyle(
                                  color: colorsGreen,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        Navigator.of(ctx).pop();
                        openDialog();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          //margin: EdgeInsets.symmetric(horizontal: 40),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: colorsGreen),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.yes,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  void mInfo() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.learnAboutUmriCalculation,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF000000)),
            ),
            content: gender == "male"
                ? Text(
                    '${AppLocalizations.of(context)!.forMale}\n${AppLocalizations.of(context)!.pubertyItIsTheAgeWhenYouFirstRealizeThatYouHaveBecomeAnAdult}\n\n${AppLocalizations.of(context)!.thinkDeepToIdentifyTheYearYouBecomeAdultAndPutItInPubertyField}\n\n${AppLocalizations.of(context)!.inTheOfferedFieldGiveAnEstimateOfHowManyPrayersYouMightHaveOffered}',
                  )
                : gender == "female"
                    ? Text(
                        "${AppLocalizations.of(context)!.forFemale}\n${AppLocalizations.of(context)!.pubertyItIsTheAgeInFemalesItsNaturalSignalIsTheFirstMensturationCycle}\n\n${AppLocalizations.of(context)!.thinkDeepToInFemalesItIsLikelyToFallBetween}\n\n${AppLocalizations.of(context)!.averageMensturationCycleDaysVariesFromDays}\n${AppLocalizations.of(context)!.numberOfChildrenWillHelpInFindingTheNIFASDays}\n${AppLocalizations.of(context)!.weHaveConsideredNIFASPeriodOfDays}\n\n${AppLocalizations.of(context)!.inTheOfferedFieldGive}")
                    : Text(
                        '${AppLocalizations.of(context)!.forMale}\n${AppLocalizations.of(context)!.pubertyItIsTheAgeWhenYouFirstRealizeThatYouHaveBecomeAnAdult}\n\n${AppLocalizations.of(context)!.thinkDeepToIdentifyTheYearYouBecomeAdultAndPutItInPubertyField}\n\n${AppLocalizations.of(context)!.inTheOfferedFieldGiveAnEstimateOfHowManyPrayersYouMightHaveOffered}\n\n                        "${AppLocalizations.of(context)!.forFemale}\n${AppLocalizations.of(context)!.pubertyItIsTheAgeInFemalesItsNaturalSignalIsTheFirstMensturationCycle}\n\n${AppLocalizations.of(context)!.thinkDeepToInFemalesItIsLikelyToFallBetween}\n\n${AppLocalizations.of(context)!.averageMensturationCycleDaysVariesFromDays}\n${AppLocalizations.of(context)!.numberOfChildrenWillHelpInFindingTheNIFASDays}\n${AppLocalizations.of(context)!.weHaveConsideredNIFASPeriodOfDays}\n\n${AppLocalizations.of(context)!.inTheOfferedFieldGive}',
                      ),
            actions: [
              Row(
                children: [
                  Expanded(child: Container()),
                  Expanded(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          //margin: EdgeInsets.symmetric(horizontal: 40),
                          decoration: BoxDecoration(
                              //border: Border.all(color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(5),
                              color: colorsGreen),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.ok,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  void snackShow() {
    Flushbar(
      title: "Hey Ninja",
      message:
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
      duration: const Duration(seconds: 3),
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundColor: colorsGreen,
      boxShadows: const [
        BoxShadow(
            color: Colors.black, offset: Offset(0.0, 2.0), blurRadius: 3.0)
      ],
      backgroundGradient:
          const LinearGradient(colors: [colorsGreen, Colors.black]),
      icon: const Icon(
        Icons.save,
        color: Colors.white,
      ),
      mainButton: InkWell(
        onTap: () {},
        child: Text(
          AppLocalizations.of(context)!.stored,
          style: TextStyle(color: Colors.amber),
        ),
      ),
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.black,
      titleText: Text(
        AppLocalizations.of(context)!.calculated,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Colors.yellow[600],
            fontFamily: "ShadowsIntoLightTwo"),
      ),
      messageText: Text(
        AppLocalizations.of(context)!.recordHasBeenAddedSuccessfully,
        style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontFamily: "ShadowsIntoLightTwo"),
      ),
    ).show(context);
  }
}
