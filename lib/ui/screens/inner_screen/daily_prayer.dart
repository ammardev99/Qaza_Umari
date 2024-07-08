// ignore_for_file: unrelated_type_equality_checks

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qaza_e_umri/constants/app_constants.dart';
import 'package:qaza_e_umri/constants/assets_path.dart';
import 'package:qaza_e_umri/core/controller/qaza_umri_controller.dart';
import 'package:qaza_e_umri/core/controller/today_qaza_controller.dart';
import 'package:qaza_e_umri/core/services/notification_services.dart';
import 'package:qaza_e_umri/ui/utils/done.dart';
import 'package:qaza_e_umri/ui/widgets/reusable_namaz_time.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../core/controller/today_controller.dart';
import '../../../core/provider/language_change_controller.dart';
import '../../../main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DailyPrayer extends StatefulWidget {
  const DailyPrayer({super.key});

  @override
  State<DailyPrayer> createState() => _DailyPrayerState();
}

enum Language { english, urdu }

class _DailyPrayerState extends State<DailyPrayer> {
  String today = '';
  String all = '';
  final TodayController _todayController = Get.put(TodayController());
  bool isToday = false;

  NotificationServices notificationServices = NotificationServices();

  bool? boolValue = true;

  int dif = 0;
  final uid = FirebaseAuth.instance.currentUser!.uid.toString();
  String offered = '';

  TextEditingController umriDaysController = TextEditingController();

  TextEditingController fjrController = TextEditingController();
  TextEditingController zhrController = TextEditingController();
  TextEditingController asrController = TextEditingController();
  TextEditingController mgrbController = TextEditingController();
  TextEditingController ishaController = TextEditingController();
  TextEditingController witrController = TextEditingController();

  @override
  void initState() {
    namazTime();
    super.initState();
  }

  // void getInitialFirebaseRecord(){
  //    FirebaseFirestore.instance
  //       .collection("namaz").doc(uid)
  //       .collection('history')
  //       .doc(getDateOfToday()).collection("Fajar").doc("Fajar").set({
  //     'name': "Fajar",
  //     'time': "0",
  //     'status': 0,
  //   });
  //
  //    FirebaseFirestore.instance
  //        .collection("namaz").doc(uid)
  //        .collection('history')
  //        .doc(getDateOfToday()).collection("Zohar").doc("Zohar").set({
  //      'name': "Zohar",
  //      'time': "0",
  //      'status': 0,
  //    });
  //
  //    FirebaseFirestore.instance
  //        .collection("namaz").doc(uid)
  //        .collection('history')
  //        .doc(getDateOfToday()).collection("Asar").doc("Asar").set({
  //      'name': "Asar",
  //      'time': "0",
  //      'status': 0,
  //    });
  //
  //    FirebaseFirestore.instance
  //        .collection("namaz").doc(uid)
  //        .collection('history')
  //        .doc(getDateOfToday()).collection("Maghrib").doc("Maghrib").set({
  //      'name': "Maghrib",
  //      'time': "0",
  //      'status': 0,
  //    });
  //
  //    FirebaseFirestore.instance
  //        .collection("namaz").doc(uid)
  //        .collection('history')
  //        .doc(getDateOfToday()).collection("Isha").doc("Isha").set({
  //      'name': "Isha",
  //      'time': "0",
  //      'status': 0,
  //    });
  //
  //    FirebaseFirestore.instance
  //        .collection("namaz").doc(uid)
  //        .collection('history')
  //        .doc(getDateOfToday()).collection("Witr").doc("Witr").set({
  //      'name': "Witr",
  //      'time': "0",
  //      'status': 0,
  //    });
  // }

  Future namazTime() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    fajarPrayerTime = preferences.getString('fajarPrayerTime')!;
    zoharPrayerTime = preferences.getString('zoharPrayerTime')!;
    asarPrayerTime = preferences.getString('asarPrayerTime')!;
    maghribPrayerTime = preferences.getString('maghribPrayerTime')!;
    ishaPrayerTime = preferences.getString('ishaPrayerTime')!;
    witrPrayerTime = preferences.getString('witrPrayerTime')!;
  }

  final QazaUmriController _qazaUmriController = Get.put(QazaUmriController());

  @override
  Widget build(BuildContext context) {
    return isToday == false
        ? SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Gap(2.h),

                /// today
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            AppLocalizations.of(context)!.today,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          Gap(.4.h),
                          Text(getDateOfToday()),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          openDialog();
                        },
                        child: const Icon(
                          mInfoIcon,
                          color: colorsGreen,
                        ),
                      ),
                      Consumer<LanguageController>(
                          builder: (context, provider, child) {
                        return PopupMenuButton(
                            onSelected: (Language item) {
                              if (Language.english.name == item.name) {
                                print("This is the English Name");

                                provider.ChangeLanguage(Locale("en"));
                              } else {
                                provider.ChangeLanguage(Locale("ur"));
                              }
                            },
                            itemBuilder: (context) =>
                                <PopupMenuEntry<Language>>[
                                  PopupMenuItem(
                                    value: Language.english,
                                    child: Text("English"),
                                  ),
                                  PopupMenuItem(
                                    value: Language.urdu,
                                    child: Text("Urdu"),
                                  ),
                                ]);
                      })
                    ],
                  ),
                ),

                /// namaz and days
                Obx(
                  () => ReusableNamazTime(
                    nameOfTheNamaz: AppLocalizations.of(context)!.fajar,
                    timeOfTheNamaz: _todayController.fjrTime.value,
                    namazStatus: _todayController.fjrStatus,
                  ),
                ),
                Obx(
                  () => ReusableNamazTime(
                    nameOfTheNamaz: AppLocalizations.of(context)!.zohar,
                    timeOfTheNamaz: _todayController.zhrTime.value,
                    namazStatus: _todayController.zhrStatus,
                  ),
                ),
                Obx(
                  () => ReusableNamazTime(
                    nameOfTheNamaz: AppLocalizations.of(context)!.asar,
                    timeOfTheNamaz: _todayController.asrTime.value,
                    namazStatus: _todayController.asrStatus,
                  ),
                ),
                Obx(
                  () => ReusableNamazTime(
                    nameOfTheNamaz: AppLocalizations.of(context)!.maghrib,
                    timeOfTheNamaz: _todayController.mgrbTime.value,
                    namazStatus: _todayController.mgrbStatus,
                  ),
                ),
                Obx(
                  () => ReusableNamazTime(
                    nameOfTheNamaz: AppLocalizations.of(context)!.isha,
                    timeOfTheNamaz: _todayController.ishaTime.value,
                    namazStatus: _todayController.ishaStatus,
                  ),
                ),
                Obx(
                  () => ReusableNamazTime(
                    nameOfTheNamaz: AppLocalizations.of(context)!.witr,
                    timeOfTheNamaz: _todayController.witrTime.value,
                    namazStatus: _todayController.witrStatus,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                ///Namaz submit button
                // InkWell(
                //   onTap: () {
                //     if ((_todayController.fjrStatus == true &&
                //             _todayController.zhrStatus == true &&
                //             _todayController.asrStatus == true &&
                //             _todayController.mgrbStatus == true &&
                //             _todayController.ishaStatus == true &&
                //             _todayController.witrStatus == true) ||
                //         DateTime.now().hour >=
                //             int.parse(witrPrayerTime[0]) + 12) {
                //       setState(() {
                //         confirmDialog();
                //       });
                //     } else {
                //       Flushbar(
                //         title: "Hey Ninja",
                //         message:
                //             "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
                //         duration: const Duration(seconds: 3),
                //         flushbarStyle: FlushbarStyle.FLOATING,
                //         reverseAnimationCurve: Curves.decelerate,
                //         forwardAnimationCurve: Curves.elasticOut,
                //         backgroundColor: colorsGreen,
                //         boxShadows: const [
                //           BoxShadow(
                //               color: Colors.black,
                //               offset: Offset(0.0, 2.0),
                //               blurRadius: 3.0)
                //         ],
                //         backgroundGradient: const LinearGradient(
                //             colors: [colorsGreen, Colors.black]),
                //         icon: const Icon(
                //           Icons.warning,
                //           color: Colors.white,
                //         ),
                //         mainButton: InkWell(
                //           onTap: () {},
                //           child: Text(
                //             AppLocalizations.of(context)!.iSIt,
                //             style: TextStyle(color: Colors.amber),
                //           ),
                //         ),
                //         showProgressIndicator: true,
                //         progressIndicatorBackgroundColor: Colors.black,
                //         titleText: Text(
                //           AppLocalizations.of(context)!.warning,
                //           style: TextStyle(
                //               fontWeight: FontWeight.bold,
                //               fontSize: 20.0,
                //               color: Colors.yellow[600],
                //               fontFamily: "ShadowsIntoLightTwo"),
                //         ),
                //         messageText: Text(
                //           AppLocalizations.of(context)!
                //               .youDidNotCompleteAllThePrayersToday,
                //           style: TextStyle(
                //               fontSize: 18.0,
                //               color: Colors.white,
                //               fontFamily: "ShadowsIntoLightTwo"),
                //         ),
                //       ).show(context);
                //     }
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.all(10.0),
                //     child: Container(
                //       height: 4.5.h,
                //       width: 35.w,
                //       decoration: BoxDecoration(
                //         color: colorsGreen,
                //         borderRadius: BorderRadius.circular(
                //             5.0), // Adjust the value for roundness
                //       ),
                //       child: Center(
                //         child: Text(
                //           AppLocalizations.of(context)!.submit,
                //           style: TextStyle(color: Colors.white),
                //         ),
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          )
        : const DonePage();
  }

  String getDateOfToday() {
    var date = DateTime.now().toString();
    var dateparse = DateTime.parse(date);
    var formattedDate = "${dateparse.day}-${dateparse.month}-${dateparse.year}";
    d = dateparse.day;
    m = dateparse.month;
    y = dateparse.year;
    return formattedDate.toString();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final User user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance
        .collection('namaz')
        .doc(user.uid)
        .get()
        .then((ds) {
      if (ds.data() != null) {
        setState(() {
          today = ds['today'];
          all = ds['all'];

          int fd = ds['day'];
          int fm = ds['month'] * 30;
          int fy = ds['year'] * 365;

          dif = (DateTime.now().day +
                  (DateTime.now().month * 30) +
                  (DateTime.now().year * 365)) -
              (fd + fm + fy);
          if (dif > 1) {
            umriConfirmation();
          }

          if (all == "done") {
            if (today == getDateOfToday()) {
              isToday = true;
            } else {
              namazStatus();
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
            }
            //isToday = true;
          } else if (all == "not done" && today != getDateOfToday()) {
            namazStatus();
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
          }
        });
      }
    });
  }

  void namazStatus() {
    setState(() {
      _todayController.fjrStatus.value = false;
      _todayController.zhrStatus.value = false;
      _todayController.asrStatus.value = false;
      _todayController.mgrbStatus.value = false;
      _todayController.ishaStatus.value = false;
      _todayController.witrStatus.value = false;
    });
    FirebaseAuth auth = FirebaseAuth.instance;
    String? uid = auth.currentUser?.uid.toString();
    DocumentReference collections = FirebaseFirestore.instance
        .collection('namaz')
        .doc(uid)
        .collection('today')
        .doc('Fajar');

    collections.update({'status': false});

    DocumentReference collections2 = FirebaseFirestore.instance
        .collection('namaz')
        .doc(uid)
        .collection('today')
        .doc('Zohar');

    collections2.update({'status': false});

    DocumentReference collections3 = FirebaseFirestore.instance
        .collection('namaz')
        .doc(uid)
        .collection('today')
        .doc('Asar');

    collections3.update({'status': false});

    DocumentReference collections4 = FirebaseFirestore.instance
        .collection('namaz')
        .doc(uid)
        .collection('today')
        .doc('Maghrib');

    collections4.update({'status': false});

    DocumentReference collections5 = FirebaseFirestore.instance
        .collection('namaz')
        .doc(uid)
        .collection('today')
        .doc('Isha');

    collections5.update({'status': false});

    DocumentReference collections6 = FirebaseFirestore.instance
        .collection('namaz')
        .doc(uid)
        .collection('today')
        .doc('Witr');

    collections6.update({'status': false});
  }

  void openDialog() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.learnAboutDailyPrayer,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF000000)),
            ),
            content: Text(
              '${AppLocalizations.of(context)!.tickMarkAgainstThePrayerNameAnd}\n\n${AppLocalizations.of(context)!.ifAnyPrayerIsNotMarkedTick}\n\n${AppLocalizations.of(context)!.updateTheRecordOfDailyPrayers}\n\n${AppLocalizations.of(context)!.userMayChangeThePrayerTimeAsPerTheirTimeZone}',
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
    FirebaseAuth auth = FirebaseAuth.instance;
    String? uid = auth.currentUser?.uid.toString();
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.confirmation,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF000000)),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(AppLocalizations.of(context)!.areYouSureYouHaveOfferedAllThePrayersToday,
                    style: TextStyle(color: Colors.black)),
              ],
            ),
            //content: Text('Please press the SAVE button at the bottom of the page'),
            actions: <Widget>[
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
                        setState(() {
                          Navigator.of(ctx).pop();
                          isToday = true;

                          if (_todayController.fjrStatus == false) {
                            _qazaUmriController.fjrTotal.value =
                                _qazaUmriController.fjrTotal.value + 1;
                            DocumentReference collections = FirebaseFirestore
                                .instance
                                .collection('namaz')
                                .doc(uid)
                                .collection('umri')
                                .doc('Fajar');

                            collections.set({
                              'name': "Fajar",
                              'total': _qazaUmriController.fjrTotal.value
                            });
                          }
                          if (_todayController.zhrStatus == false) {
                            _qazaUmriController.zhrTotal.value =
                                _qazaUmriController.zhrTotal.value + 1;
                            DocumentReference collections2 = FirebaseFirestore
                                .instance
                                .collection('namaz')
                                .doc(uid)
                                .collection('umri')
                                .doc('Zohar');

                            collections2.set({
                              'name': "Zohar",
                              'total': _qazaUmriController.zhrTotal.value
                            });
                          }
                          if (_todayController.asrStatus == false) {
                            _qazaUmriController.asrTotal.value =
                                _qazaUmriController.asrTotal.value + 1;

                            DocumentReference collections3 = FirebaseFirestore
                                .instance
                                .collection('namaz')
                                .doc(uid)
                                .collection('umri')
                                .doc('Asar');

                            collections3.set({
                              'name': "Asar",
                              'total': _qazaUmriController.asrTotal.value
                            });
                          }
                          if (_todayController.mgrbStatus == false) {
                            _qazaUmriController.mgrbTotal.value =
                                _qazaUmriController.mgrbTotal.value + 1;

                            DocumentReference collections4 = FirebaseFirestore
                                .instance
                                .collection('namaz')
                                .doc(uid)
                                .collection('umri')
                                .doc('Maghrib');

                            collections4.set({
                              'name': "Maghrib",
                              'total': _qazaUmriController.mgrbTotal.value
                            });
                          }
                          if (_todayController.ishaStatus == false) {
                            _qazaUmriController.ishaTotal.value =
                                _qazaUmriController.ishaTotal.value + 1;

                            DocumentReference collections5 = FirebaseFirestore
                                .instance
                                .collection('namaz')
                                .doc(uid)
                                .collection('umri')
                                .doc('Isha');

                            collections5.set({
                              'name': "Isha",
                              'total': _qazaUmriController.ishaTotal.value
                            });
                          }
                          if (_todayController.witrStatus == false) {
                            _qazaUmriController.witrTotal.value =
                                _qazaUmriController.witrTotal.value + 1;

                            DocumentReference collections6 = FirebaseFirestore
                                .instance
                                .collection('namaz')
                                .doc(uid)
                                .collection('umri')
                                .doc('Witr');

                            collections6.set({
                              'name': "Witr",
                              'total': _qazaUmriController.witrTotal.value
                            });
                          }

                          DocumentReference collection = FirebaseFirestore
                              .instance
                              .collection('namaz')
                              .doc(uid);

                          collection.set({
                            'today': getDateOfToday(),
                            'all': "done",
                            'day': d,
                            'month': m,
                            'year': y
                          });

                          Future.delayed(const Duration(microseconds: 1))
                              .then((value) {
                            snackShow();
                          });
                        });

                        notify();
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
                          child:  Center(
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

  void notify() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var month = DateTime.now().month.toString().length == 1
        ? "0${DateTime.now().month}"
        : DateTime.now().month;
    var day = DateTime.now().day.toString().length == 1
        ? "0${DateTime.now().day + 1}"
        : DateTime.now().day + 1;

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        scheduleTime = [
          "${DateTime.now().year}-$month-$day 0${Get.put(TodayQazaController()).fjrQaza.value}:${Get.put(TodayQazaController()).fjrMinutes.value}:00.000",
          "${DateTime.now().year}-$month-$day ${int.parse(Get.put(TodayQazaController()).zhrQaza.value) + 12}:${Get.put(TodayQazaController()).zhrMinutes.value}:00.000",
          "${DateTime.now().year}-$month-$day ${int.parse(Get.put(TodayQazaController()).asrQaza.value) + 12}:${Get.put(TodayQazaController()).asrMinutes.value}:00.000",
          "${DateTime.now().year}-$month-$day ${int.parse(Get.put(TodayQazaController()).mgrbQaza.value) + 12}:${Get.put(TodayQazaController()).mgrbMinutes.value}:00.000",
          "${DateTime.now().year}-$month-$day ${int.parse(Get.put(TodayQazaController()).ishaQaza.value) + 12}:${Get.put(TodayQazaController()).ishaMinutes.value}:00.000",
          "${DateTime.now().year}-$month-$day ${int.parse(Get.put(TodayQazaController()).ishaQaza.value) + 13}:${Get.put(TodayQazaController()).ishaMinutes.value}:00.000"
        ];
        //print(scheduleTime);
        if (prefs.getBool('boolValue') != null) {
          boolValue = prefs.getBool('boolValue');
          if (boolValue == true) {
            for (int i = 0; i <= 5; i++) {
              NotificationServices().scheduleNotification(
                  id: i,
                  title: title[i],
                  body: note[i],
                  scheduledNotificationDateTime:
                      DateTime.tryParse(scheduleTime[i])!);
            }
          } else {
            notificationServices.stopNotifications();
          }
        } else {
          for (int i = 0; i <= 5; i++) {
            NotificationServices().scheduleNotification(
                id: i,
                title: title[i],
                body: note[i],
                scheduledNotificationDateTime:
                    DateTime.tryParse(scheduleTime[i])!);
          }
        }
      });
    });
  }

  void umriConfirmation() {
    FirebaseAuth auth = FirebaseAuth.instance;
    String? uid = auth.currentUser?.uid.toString();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.qazaUmriConfirmation,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF000000)),
            ),
            content: StatefulBuilder(builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text('${AppLocalizations.of(context)!.qazaUmriLeftFor} $dif ${AppLocalizations.of(context)!.daysDoYouWantToAdd}',
                      style: const TextStyle(color: Colors.black)),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Icon(Icons.done),
                      Text(
                        AppLocalizations.of(context)!.didYouOfferAnyPrayerInTheseDays,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
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
                  offered == 'yes'
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
                                          keyboardType: TextInputType.number,
                                          cursorColor: colorsGreen,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorsGreen),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorsGreen),
                                            ),
                                            //border: OutlineInputBorder(),
                                            hintText: AppLocalizations.of(context)!.fajar,
                                            hintStyle: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "/$dif",
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
                                          keyboardType: TextInputType.number,
                                          cursorColor: colorsGreen,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorsGreen),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorsGreen),
                                            ),
                                            //border: OutlineInputBorder(),
                                            hintText: AppLocalizations.of(context)!.zohar,
                                            hintStyle: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "/$dif",
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
                                          keyboardType: TextInputType.number,
                                          cursorColor: colorsGreen,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorsGreen),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorsGreen),
                                            ),
                                            //border: OutlineInputBorder(),
                                            hintText: AppLocalizations.of(context)!.asar,
                                            hintStyle: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "/$dif",
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
                                          keyboardType: TextInputType.number,
                                          cursorColor: colorsGreen,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorsGreen),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorsGreen),
                                            ),
                                            //border: OutlineInputBorder(),
                                            hintText: AppLocalizations.of(context)!.maghrib,
                                            hintStyle: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "/$dif",
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
                                            keyboardType: TextInputType.number,
                                            cursorColor: colorsGreen,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            decoration: InputDecoration(
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
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "/$dif",
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
                                            keyboardType: TextInputType.number,
                                            cursorColor: colorsGreen,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            decoration: InputDecoration(
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
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "/$dif",
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
                ],
              );
            }),
            //content: Text('Please press the SAVE button at the bottom of the page'),
            actions: <Widget>[
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
                        DocumentReference collection = FirebaseFirestore
                            .instance
                            .collection('namaz')
                            .doc(uid);

                        collection.set({
                          'today': getDateOfToday(),
                          'all': "not done",
                          'day': d,
                          'month': m,
                          'year': y
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        setState(() {
                          saveUmri();
                        });
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

  Future<void> saveUmri() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String? uid = auth.currentUser?.uid.toString();

    int fjr = fjrController.text.isEmpty || int.parse(fjrController.text) > dif
        ? 0
        : int.parse(fjrController.text);
    int zhr = zhrController.text.isEmpty || int.parse(zhrController.text) > dif
        ? 0
        : int.parse(zhrController.text);
    int asr = asrController.text.isEmpty || int.parse(asrController.text) > dif
        ? 0
        : int.parse(asrController.text);
    int mgrb =
        mgrbController.text.isEmpty || int.parse(mgrbController.text) > dif
            ? 0
            : int.parse(mgrbController.text);
    int isha =
        ishaController.text.isEmpty || int.parse(ishaController.text) > dif
            ? 0
            : int.parse(ishaController.text);
    int witr =
        witrController.text.isEmpty || int.parse(witrController.text) > dif
            ? 0
            : int.parse(witrController.text);

    _qazaUmriController.fjrTotal.value =
        (_qazaUmriController.fjrTotal.value + dif) - fjr;
    _qazaUmriController.zhrTotal.value =
        (_qazaUmriController.zhrTotal.value + dif) - zhr;
    _qazaUmriController.asrTotal.value =
        (_qazaUmriController.asrTotal.value + dif) - asr;
    _qazaUmriController.mgrbTotal.value =
        (_qazaUmriController.mgrbTotal.value + dif) - mgrb;
    _qazaUmriController.ishaTotal.value =
        (_qazaUmriController.ishaTotal.value + dif) - isha;
    _qazaUmriController.witrTotal.value =
        _qazaUmriController.witrTotal.value + dif - witr;

    dif = 0;

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
        .collection('umri')
        .doc('Fajar');

    collections
        .set({'name': "Fajar", 'total': _qazaUmriController.fjrTotal.value});

    DocumentReference collections2 = FirebaseFirestore.instance
        .collection('namaz')
        .doc(uid)
        .collection('umri')
        .doc('Zohar');

    collections2
        .set({'name': "Zohar", 'total': _qazaUmriController.zhrTotal.value});

    DocumentReference collections3 = FirebaseFirestore.instance
        .collection('namaz')
        .doc(uid)
        .collection('umri')
        .doc('Asar');

    collections3
        .set({'name': "Asar", 'total': _qazaUmriController.asrTotal.value});

    DocumentReference collections4 = FirebaseFirestore.instance
        .collection('namaz')
        .doc(uid)
        .collection('umri')
        .doc('Maghrib');

    collections4
        .set({'name': "Maghrib", 'total': _qazaUmriController.mgrbTotal.value});

    DocumentReference collections5 = FirebaseFirestore.instance
        .collection('namaz')
        .doc(uid)
        .collection('umri')
        .doc('Isha');

    collections5
        .set({'name': "Isha", 'total': _qazaUmriController.ishaTotal.value});

    DocumentReference collections6 = FirebaseFirestore.instance
        .collection('namaz')
        .doc(uid)
        .collection('umri')
        .doc('Witr');

    collections6
        .set({'name': "Witr", 'total': _qazaUmriController.witrTotal.value});
    Future.delayed(const Duration(microseconds: 1)).then((value) {
      snackShow();
    });
    Navigator.of(context).pop();
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
          // "",
          AppLocalizations.of(context)!.stored,
          style: TextStyle(color: Colors.amber),
        ),
      ),
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.black,
      titleText: Text(
        // "",
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
