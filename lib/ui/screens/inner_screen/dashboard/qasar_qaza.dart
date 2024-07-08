import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:qaza_e_umri/constants/app_constants.dart';
import 'package:qaza_e_umri/core/controller/qasar_qaza_controller.dart';
import 'package:qaza_e_umri/constants/assets_path.dart';
import 'package:qaza_e_umri/ui/widgets/reusable_qasar_qaza.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QasarQaza extends StatefulWidget {
  const QasarQaza({super.key});

  @override
  State<QasarQaza> createState() => _QasarQazaState();
}

class _QasarQazaState extends State<QasarQaza> {
  int total = 0;
  String today = '';
  String all = '';
  final QasarQazaController _qasarQazaController =
      Get.put(QasarQazaController());
  bool isToday = false;

  String offered = '';

  TextEditingController qasarDaysController = TextEditingController();

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
                        AppLocalizations.of(context)!.qasarQazaRecord,
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
              () => ReusableQasarQaza(
                nameOfTheNamaz: _qasarQazaController.fjrName.value,
                totalNamaz: _qasarQazaController.fjrTotal.value,
              ),
            ),
            Obx(
              () => ReusableQasarQaza(
                nameOfTheNamaz: _qasarQazaController.zhrName.value,
                totalNamaz: _qasarQazaController.zhrTotal.value,
              ),
            ),
            Obx(
              () => ReusableQasarQaza(
                nameOfTheNamaz: _qasarQazaController.asrName.value,
                totalNamaz: _qasarQazaController.asrTotal.value,
              ),
            ),
            Obx(
              () => ReusableQasarQaza(
                nameOfTheNamaz: _qasarQazaController.mgrbName.value,
                totalNamaz: _qasarQazaController.mgrbTotal.value,
              ),
            ),
            Obx(() => ReusableQasarQaza(
                  nameOfTheNamaz: _qasarQazaController.ishaName.value,
                  totalNamaz: _qasarQazaController.ishaTotal.value,
                )),
            Obx(() => ReusableQasarQaza(
                  nameOfTheNamaz: _qasarQazaController.witrName.value,
                  totalNamaz: _qasarQazaController.witrTotal.value,
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_qasarQazaController.fjrTotal.value > 0 ||
              _qasarQazaController.zhrTotal.value > 0 ||
              _qasarQazaController.asrTotal.value > 0 ||
              _qasarQazaController.mgrbTotal.value > 0 ||
              _qasarQazaController.ishaTotal.value > 0 ||
              _qasarQazaController.witrTotal.value > 0) {
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

  Future<void> saveQasar(context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String? uid = auth.currentUser?.uid.toString();

    int fjr = fjrController.text.isEmpty ? 0 : int.parse(fjrController.text);
    int zhr = zhrController.text.isEmpty ? 0 : int.parse(zhrController.text);
    int asr = asrController.text.isEmpty ? 0 : int.parse(asrController.text);
    int mgrb = mgrbController.text.isEmpty ? 0 : int.parse(mgrbController.text);
    int isha = ishaController.text.isEmpty ? 0 : int.parse(ishaController.text);
    int witr = witrController.text.isEmpty ? 0 : int.parse(witrController.text);

    _qasarQazaController.fjrTotal.value = _qasarQazaController.fjrTotal.value +
        int.parse(qasarDaysController.text) -
        fjr;
    _qasarQazaController.zhrTotal.value = _qasarQazaController.zhrTotal.value +
        int.parse(qasarDaysController.text) -
        zhr;
    _qasarQazaController.asrTotal.value = _qasarQazaController.asrTotal.value +
        int.parse(qasarDaysController.text) -
        asr;
    _qasarQazaController.mgrbTotal.value =
        _qasarQazaController.mgrbTotal.value +
            int.parse(qasarDaysController.text) -
            mgrb;
    _qasarQazaController.ishaTotal.value =
        _qasarQazaController.ishaTotal.value +
            int.parse(qasarDaysController.text) -
            isha;
    _qasarQazaController.witrTotal.value =
        _qasarQazaController.witrTotal.value +
            int.parse(qasarDaysController.text) -
            witr;

    total = 0;

    DocumentReference collections = FirebaseFirestore.instance
        .collection('namaz')
        .doc(uid)
        .collection('qasar')
        .doc('Fajar');

    collections
        .set({'name': "Fajar", 'total': _qasarQazaController.fjrTotal.value});

    DocumentReference collections2 = FirebaseFirestore.instance
        .collection('namaz')
        .doc(uid)
        .collection('qasar')
        .doc('Zohar');

    collections2
        .set({'name': "Zohar", 'total': _qasarQazaController.zhrTotal.value});

    DocumentReference collections3 = FirebaseFirestore.instance
        .collection('namaz')
        .doc(uid)
        .collection('qasar')
        .doc('Asar');

    collections3
        .set({'name': "Asar", 'total': _qasarQazaController.asrTotal.value});

    DocumentReference collections4 = FirebaseFirestore.instance
        .collection('namaz')
        .doc(uid)
        .collection('qasar')
        .doc('Maghrib');

    collections4.set(
        {'name': "Maghrib", 'total': _qasarQazaController.mgrbTotal.value});

    DocumentReference collections5 = FirebaseFirestore.instance
        .collection('namaz')
        .doc(uid)
        .collection('qasar')
        .doc('Isha');

    collections5
        .set({'name': "Isha", 'total': _qasarQazaController.ishaTotal.value});

    DocumentReference collections6 = FirebaseFirestore.instance
        .collection('namaz')
        .doc(uid)
        .collection('qasar')
        .doc('Witr');

    collections6
        .set({'name': "Witr", 'total': _qasarQazaController.witrTotal.value});
    Future.delayed(const Duration(microseconds: 1)).then((value) {
      snackShow();
    });
    fjrController.clear();
    zhrController.clear();
    asrController.clear();
    mgrbController.clear();
    ishaController.clear();
    witrController.clear();
    qasarDaysController.clear();
    offered = '';
    Navigator.of(context).pop();
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
                  AppLocalizations.of(context)!.qasarCalculator,
                ),
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
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Icon(Icons.travel_explore_outlined),
                            Text(
                              AppLocalizations.of(context)!.enterDaysTravelled,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: qasarDaysController,
                            onChanged: (value) {
                              setState(() {
                                qasarDaysController.text = value;
                              });
                            },
                            keyboardType: TextInputType.number,
                            cursorColor: colorsGreen,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: colorsGreen),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: colorsGreen),
                              ),
                              //border: OutlineInputBorder(),
                              hintText: '',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Icon(Icons.done),
                            Text(
                              AppLocalizations.of(context)!.didYouOfferAnyPrayerInTheseDays,
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
                                title: Text(AppLocalizations.of(context)!.yes),
                                value: "yes",
                                groupValue: offered,
                                onChanged: (value) {
                                  setState(() {
                                    offered = value.toString();
                                    //print(offered);
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                activeColor: colorsGreen,
                                //controlAffinity: ListTileControlAffinity.trailing,
                                title: Text(AppLocalizations.of(context)!.no),
                                value: "no",
                                groupValue: offered,
                                onChanged: (value) {
                                  setState(() {
                                    offered = value.toString();
                                    //print(offered);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        offered == 'yes' && qasarDaysController.text.isNotEmpty
                            ? Column(
                                children: [
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
                                                keyboardType:
                                                    TextInputType.number,
                                                cursorColor: colorsGreen,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                decoration:
                                                     InputDecoration(
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: colorsGreen),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: colorsGreen),
                                                  ),
                                                  //border: OutlineInputBorder(),
                                                  hintText: AppLocalizations.of(context)!.fajar,
                                                  hintStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "/${qasarDaysController.text}",
                                              style: const TextStyle(
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
                                                keyboardType:
                                                    TextInputType.number,
                                                cursorColor: colorsGreen,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                decoration:
                                                     InputDecoration(
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: colorsGreen),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: colorsGreen),
                                                  ),
                                                  //border: OutlineInputBorder(),
                                                  hintText: AppLocalizations.of(context)!.zohar,
                                                  hintStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "/${qasarDaysController.text}",
                                              style: const TextStyle(
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
                                                keyboardType:
                                                    TextInputType.number,
                                                cursorColor: colorsGreen,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                decoration:
                                                     InputDecoration(
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: colorsGreen),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: colorsGreen),
                                                  ),
                                                  //border: OutlineInputBorder(),
                                                  hintText: AppLocalizations.of(context)!.asar,
                                                  hintStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "/${qasarDaysController.text}",
                                              style: const TextStyle(
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
                                                keyboardType:
                                                    TextInputType.number,
                                                cursorColor: colorsGreen,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                decoration:
                                                InputDecoration(
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: colorsGreen),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: colorsGreen),
                                                  ),
                                                  //border: OutlineInputBorder(),
                                                  hintText: AppLocalizations.of(context)!.maghrib,
                                                  hintStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "/${qasarDaysController.text}",
                                              style: const TextStyle(
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
                                                  keyboardType:
                                                      TextInputType.number,
                                                  cursorColor: colorsGreen,
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  decoration:
                                                       InputDecoration(
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: colorsGreen),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: colorsGreen),
                                                    ),
                                                    //border: OutlineInputBorder(),
                                                    hintText: AppLocalizations.of(context)!.isha,
                                                    hintStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "/${qasarDaysController.text}",
                                                style: const TextStyle(
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
                                                  keyboardType:
                                                      TextInputType.number,
                                                  cursorColor: colorsGreen,
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  decoration:
                                                       InputDecoration(
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: colorsGreen),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: colorsGreen),
                                                    ),
                                                    //border: OutlineInputBorder(),
                                                    hintText: AppLocalizations.of(context)!.witr,
                                                    hintStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "/${qasarDaysController.text}",
                                                style: const TextStyle(
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
                                ],
                              )
                            : Container(),
                        const SizedBox(
                          height: 30,
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
                                        // "",
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
                                  if (qasarDaysController.text.isNotEmpty &&
                                      qasarDaysController.text.toString() !=
                                          '0') {
                                    offered == "no"
                                        ? saveQasar(context)
                                        : fjrController.text.isNotEmpty &&
                                                zhrController.text.isNotEmpty &&
                                                asrController.text.isNotEmpty &&
                                                mgrbController
                                                    .text.isNotEmpty &&
                                                ishaController
                                                    .text.isNotEmpty &&
                                                witrController
                                                    .text.isNotEmpty &&
                                                int.parse(qasarDaysController.text) >=
                                                    int.parse(
                                                        fjrController.text) &&
                                                int.parse(qasarDaysController.text) >=
                                                    int.parse(
                                                        zhrController.text) &&
                                                int.parse(qasarDaysController.text) >=
                                                    int.parse(
                                                        asrController.text) &&
                                                int.parse(qasarDaysController.text) >=
                                                    int.parse(
                                                        mgrbController.text) &&
                                                int.parse(qasarDaysController
                                                        .text) >=
                                                    int.parse(
                                                        ishaController.text) &&
                                                int.parse(qasarDaysController
                                                        .text) >=
                                                    int.parse(
                                                        witrController.text)
                                            ? saveQasar(context)
                                            : ScaffoldMessenger.of(context)
                                                .showSnackBar( SnackBar(
                                                    content:
                                                        Text(AppLocalizations.of(context)!.fillUpAllTheFieldsCorrectly
                                                        )));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                         SnackBar(
                                            content: Text(
                                                AppLocalizations.of(context)!.fillUpAllTheFieldsCorrectly)));
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
              }));
        });
  }

  void confirmDialog() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.doYouWantToAddQasarNamaz,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF000000)),
            ),
            content: Text(
              AppLocalizations.of(context)!.thisWillAddQasarNamazInYourPreviousRecord,
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

  void infoDialog() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.learnAboutQasarQaza,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF000000)),
            ),
            content: Text(
              AppLocalizations.of(context)!.thisIsQasarQazaRecord,
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
