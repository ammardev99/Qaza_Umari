import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:qaza_e_umri/constants/app_constants.dart';
import 'package:qaza_e_umri/constants/assets_path.dart';
import 'package:qaza_e_umri/core/controller/today_controller.dart';
import 'package:qaza_e_umri/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../../core/controller/today_qaza_controller.dart';
import '../../core/services/notification_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class ReusableNamazTime extends StatefulWidget {
  final String nameOfTheNamaz;
  String timeOfTheNamaz;
  RxBool namazStatus;
  ReusableNamazTime(
      {super.key,
        required this.nameOfTheNamaz,
        required this.timeOfTheNamaz,
        required this.namazStatus});

  @override
  State<ReusableNamazTime> createState() => _ReusableNamazTimeState();
}

class _ReusableNamazTimeState extends State<ReusableNamazTime> {
  int namazU = 1;
  int dayDifference = 0;
  int monthDifference = 0;

  TextEditingController timeinput = TextEditingController();

  final TodayController _todayController = Get.put(TodayController());

  final _todayQazaController = Get.put(TodayQazaController());

  // ignore: prefer_typing_uninitialized_variables
  var scheduleTime;
  var month = DateTime.now().month.toString().length == 1
      ? "0${DateTime.now().month}"
      : DateTime.now().month;
  var day = DateTime.now().day.toString().length == 1
      ? "0${DateTime.now().day}"
      : DateTime.now().day;

  @override
  void initState() {
    super.initState();
    _checkAndCreateCollection();
  }

  Future<void> _createCollectionAndSetDate() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String? uid = auth.currentUser?.uid.toString();
    DocumentReference collection6 = FirebaseFirestore.instance
        .collection("history")
        .doc(uid)
        .collection('allNamaz')
        .doc(getDateOfToday());

    await collection6.set({
      'Fajar': 1,
      'Zohar': 1,
      'Asar': 1,
      'Maghrib': 1,
      'Isha': 1,
      'Witr' : 1,
      'date': getDateOfToday(),
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String formattedDate = "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
    await prefs.setString('TodayDate', formattedDate);
  }

  Future<void> _checkAndCreateCollection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dateOfLastAdded = prefs.getString("TodayDate");
    if (dateOfLastAdded == null) {
      await _createCollectionAndSetDate();
    } else {
      final lastDate = DateFormat('dd-MM-yyyy').parse(dateOfLastAdded);
      final currentDate = DateTime.now();
      dayDifference = currentDate.difference(lastDate).inDays;
      monthDifference = currentDate.month - lastDate.month;

      if (dayDifference >= 1) {
        await _createCollectionAndSetDate();
      }

      if (monthDifference != 0) {

      }
    }
  }









  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    String? uid = auth.currentUser?.uid.toString();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 5.7.h,
        decoration: BoxDecoration(
          color: const Color(0xffE8E9EB),
          borderRadius:
          BorderRadius.circular(5.0), // Adjust the value for roundness
        ),
        child: Row(
          children: [
            Gap(3.w),
            Text(
              widget.nameOfTheNamaz,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            IntrinsicWidth(
                child: Center(
                    child: TextField(
                      controller: timeinput
                        ..text = widget
                            .timeOfTheNamaz, //editing controller of this TextField
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          timerIcon,
                          color: Colors.black,
                        ), //icon of text field
                        //labelText: "Enter Time" //label text of field
                      ),
                      readOnly:
                      true, //set it true, so that user will not able to edit text
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );

                        if (pickedTime != null) {
                          // print(pickedTime.format(context));   //output 10:51 PM
                          // DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                          // //converting to DateTime so that we can further format on different pattern.
                          // print(parsedTime); //output 1970-01-01 22:53:00.000
                          // String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
                          // print(formattedTime); //output 14:59:00
                          //DateFormat() is from intl package, you can format the time on any pattern you need.
                          // ignore: use_build_context_synchronously
                          String a = pickedTime.format(context);

                          setState(() async {
                            timeinput.text = a; //set the value of text field.
                            widget.timeOfTheNamaz = a;

                            SharedPreferences preferences =
                            await SharedPreferences.getInstance();

                            if (widget.nameOfTheNamaz == "Fajar") {
                              _todayController.fjrTime.value = a;

                              fajarPrayerTime = _todayController.fjrTime.value;
                              // DocumentReference collection = FirebaseFirestore.instance
                              //     .collection("history").doc(uid)
                              //     .collection('allNamaz')
                              //     .doc(getDateOfToday());
                              // collection6.update({
                              //   // 'name': widget.nameOfTheNamaz,
                              //   // 'time': widget.timeOfTheNamaz,
                              //   // widget.nameOfTheNamaz : 1,
                              //   'Fajar':0,
                              //   //  'Zohar':1,
                              //   // 'Asar':1,

                              //   //  'Maghrib':1,
                              //   //  'Isha':1,

                              // });
                              await preferences.setString(
                                  'fajarPrayerTime', fajarPrayerTime);
                            }
                            if (widget.nameOfTheNamaz == "Zohar") {
                              _todayController.zhrTime.value = a;
                              zoharPrayerTime = _todayController.zhrTime.value;
                              await preferences.setString(
                                  'zoharPrayerTime', zoharPrayerTime);
                            }
                            if (widget.nameOfTheNamaz == "Asar") {
                              _todayController.asrTime.value = a;
                              asarPrayerTime = _todayController.asrTime.value;
                              await preferences.setString(
                                  'asarPrayerTime', asarPrayerTime);
                            }
                            if (widget.nameOfTheNamaz == "Maghrib") {
                              _todayController.mgrbTime.value = a;
                              maghribPrayerTime = _todayController.mgrbTime.value;
                              await preferences.setString(
                                  'maghribPrayerTime', maghribPrayerTime);
                            }
                            if (widget.nameOfTheNamaz == "Isha") {
                              _todayController.ishaTime.value = a;
                              ishaPrayerTime = _todayController.ishaTime.value;
                              await preferences.setString(
                                  'ishaPrayerTime', ishaPrayerTime);
                            }
                            if (widget.nameOfTheNamaz == "Witr") {
                              _todayController.witrTime.value = a;
                              witrPrayerTime = _todayController.witrTime.value;
                              await preferences.setString(
                                  'witrPrayerTime', witrPrayerTime);
                            }

                            DocumentReference collections5 = FirebaseFirestore.instance
                                .collection('namaz')
                                .doc(uid)
                                .collection('today')
                                .doc(widget.nameOfTheNamaz);

                            collections5.set({
                              'name': widget.nameOfTheNamaz,
                              'time': a,
                              'status': widget.namazStatus.value
                            });
                            scheduleTime = [
                              widget.nameOfTheNamaz == "Fajar"
                                  ? "${DateTime.now().year}-$month-$day 0${a[0]}:${a[2]}${a[3]}:00.000"
                                  : "${DateTime.now().year}-$month-$day 0${_todayQazaController.fjrQaza.value}:${_todayQazaController.fjrMinutes.value}:00.000",
                              widget.nameOfTheNamaz == "Zohar"
                                  ? "${DateTime.now().year}-$month-$day ${int.parse(a[0]) + 12}:${a[2]}${a[3]}:00.000"
                                  : "${DateTime.now().year}-$month-$day ${int.parse(_todayQazaController.zhrQaza.value) + 12}:${_todayQazaController.zhrMinutes.value}:00.000",
                              widget.nameOfTheNamaz == "Asar"
                                  ? "${DateTime.now().year}-$month-$day ${int.parse(a[0]) + 12}:${a[2]}${a[3]}:00.000"
                                  : "${DateTime.now().year}-$month-$day ${int.parse(_todayQazaController.asrQaza.value) + 12}:${_todayQazaController.asrMinutes.value}:00.000",
                              widget.nameOfTheNamaz == "Maghrib"
                                  ? "${DateTime.now().year}-$month-$day ${int.parse(a[0]) + 12}:${a[2]}${a[3]}:00.000"
                                  : "${DateTime.now().year}-$month-$day ${int.parse(_todayQazaController.mgrbQaza.value) + 12}:${_todayQazaController.mgrbMinutes.value}:00.000",
                              widget.nameOfTheNamaz == "Isha"
                                  ? "${DateTime.now().year}-$month-$day ${int.parse(_todayQazaController.ishaQaza.value) + 12}:${_todayQazaController.ishaMinutes.value}:00.000"
                                  : "${DateTime.now().year}-$month-$day ${int.parse(a[0]) + 12}:${a[2]}${a[3]}:00.000",
                              "${DateTime.now().year}-$month-$day ${int.parse(Get.put(TodayQazaController()).ishaQaza.value) + 13}:${Get.put(TodayQazaController()).ishaMinutes.value}:00.000"
                            ];
                            //print(scheduleTime);
                            for (int i = 0; i <= 5; i++) {
                              NotificationServices().scheduleNotification(
                                  id: i,
                                  title: title[i],
                                  body: note[i],
                                  scheduledNotificationDateTime:
                                  DateTime.tryParse(scheduleTime[i])!);
                            }
                          });
                        } else {
                          //print("Time is not selected");
                        }
                      },
                    ))),
            Gap(9.w),
            Checkbox(
                checkColor: Colors.white,
                activeColor: Colors.green,
                value: widget.namazStatus.value,
                onChanged: ((v) {
                  setState(() {

                    if (widget.nameOfTheNamaz == "Fajar") {
                      widget.namazStatus.value = v!;
                      _todayQazaController.fjrStatus.value =
                          widget.namazStatus.value;
                      if(v == true){
                        DocumentReference collection6 = FirebaseFirestore.instance
                            .collection("history").doc(uid)
                            .collection('allNamaz')
                            .doc(getDateOfToday());
                        collection6.update({
                          // 'name': widget.nameOfTheNamaz,
                          // 'time': widget.timeOfTheNamaz,
                          // widget.nameOfTheNamaz : 1,
                          'Fajar':0,
                        
                          // 'Zohar':1,
                          // 'Asar':1,
                          // 'Maghrib':1,
                          // 'Isha':1,

                        });
                      }
                      else{
                        DocumentReference collection6 = FirebaseFirestore.instance
                            .collection("history").doc(uid)
                            .collection('allNamaz')
                            .doc(getDateOfToday());
                        collection6.update({
                          // 'name': widget.nameOfTheNamaz,
                          // 'time': widget.timeOfTheNamaz,
                          // widget.nameOfTheNamaz : 1,
                          'Fajar':1,
                          // 'Zohar':1,
                          // 'Asar':1,
                          // 'Maghrib':1,
                          // 'Isha':1,

                        });
                      }

                      if (widget.namazStatus.value == true) {
                        snackShow();
                      }
                    }
                    if (widget.nameOfTheNamaz == "Zohar") {
                      widget.namazStatus.value = v!;
                      _todayQazaController.zhrStatus.value =
                          widget.namazStatus.value;
                      if(v == true){
                        DocumentReference collection6 = FirebaseFirestore.instance
                            .collection("history").doc(uid)
                            .collection('allNamaz')
                            .doc(getDateOfToday());
                        collection6.update({
                          // 'name': widget.nameOfTheNamaz,
                          // 'time': widget.timeOfTheNamaz,
                          // widget.nameOfTheNamaz : 1,
                          // 'Fajar':0,
                          'Zohar':0,
                          // 'Asar':1,
                          // 'Maghrib':1,
                          // 'Isha':1,

                        });
                      }
                      else{
                        DocumentReference collection6 = FirebaseFirestore.instance
                            .collection("history").doc(uid)
                            .collection('allNamaz')
                            .doc(getDateOfToday());
                        collection6.update({
                          // 'name': widget.nameOfTheNamaz,
                          // 'time': widget.timeOfTheNamaz,
                          // widget.nameOfTheNamaz : 1,
                          // 'Fajar':1,
                          'Zohar':1,
                          // 'Asar':1,
                          // 'Maghrib':1,
                          // 'Isha':1,

                        });
                      }
                      if (widget.namazStatus.value == true) {
                        snackShow();
                      }
                    }
                    if (widget.nameOfTheNamaz == "Asar") {
                      widget.namazStatus.value = v!;
                      _todayQazaController.asrStatus.value =
                          widget.namazStatus.value;
                      if(v == true){
                        DocumentReference collection6 = FirebaseFirestore.instance
                            .collection("history").doc(uid)
                            .collection('allNamaz')
                            .doc(getDateOfToday());
                        collection6.update({
                          // 'name': widget.nameOfTheNamaz,
                          // 'time': widget.timeOfTheNamaz,
                          // widget.nameOfTheNamaz : 1,
                          // 'Fajar':0,
                          // 'Zohar':1,
                          'Asar':0,
                          // 'Maghrib':1,
                          // 'Isha':1,

                        });
                      }
                      else{
                        DocumentReference collection6 = FirebaseFirestore.instance
                            .collection("history").doc(uid)
                            .collection('allNamaz')
                            .doc(getDateOfToday());
                        collection6.update({
                          // 'name': widget.nameOfTheNamaz,
                          // 'time': widget.timeOfTheNamaz,
                          // widget.nameOfTheNamaz : 1,
                          // 'Fajar':1,
                          // 'Zohar':1,
                          'Asar':1,
                          // 'Maghrib':1,
                          // 'Isha':1,

                        });
                      }
                      if (widget.namazStatus.value == true) {
                        snackShow();
                      }
                    }
                    if (widget.nameOfTheNamaz == "Maghrib") {
                      widget.namazStatus.value = v!;
                      _todayQazaController.mgrbStatus.value =
                          widget.namazStatus.value;
                      if(v == true){
                        DocumentReference collection6 = FirebaseFirestore.instance
                            .collection("history").doc(uid)
                            .collection('allNamaz')
                            .doc(getDateOfToday());
                        collection6.update({
                          // 'name': widget.nameOfTheNamaz,
                          // 'time': widget.timeOfTheNamaz,
                          // widget.nameOfTheNamaz : 1,
                          // 'Fajar':0,
                          // 'Zohar':1,
                          // 'Asar':1,
                          'Maghrib':0,
                          // 'Isha':1,

                        });
                      }
                      else{
                        DocumentReference collection6 = FirebaseFirestore.instance
                            .collection("history").doc(uid)
                            .collection('allNamaz')
                            .doc(getDateOfToday());
                        collection6.update({
                          // 'name': widget.nameOfTheNamaz,
                          // 'time': widget.timeOfTheNamaz,
                          // widget.nameOfTheNamaz : 1,
                          // 'Fajar':1,
                          // 'Zohar':1,
                          // 'Asar':1,
                          'Maghrib':1,
                          // 'Isha':1,

                        });
                      }
                      if (widget.namazStatus.value == true) {
                        snackShow();
                      }
                    }
                    if (widget.nameOfTheNamaz == "Isha") {
                      widget.namazStatus.value = v!;
                      _todayQazaController.ishaStatus.value =
                          widget.namazStatus.value;
                      if(v == true){
                        DocumentReference collection6 = FirebaseFirestore.instance
                            .collection("history").doc(uid)
                            .collection('allNamaz')
                            .doc(getDateOfToday());
                        collection6.update({
                          // 'name': widget.nameOfTheNamaz,
                          // 'time': widget.timeOfTheNamaz,
                          // widget.nameOfTheNamaz : 1,
                          // 'Fajar':0,
                          // 'Zohar':1,
                          // 'Asar':1,
                          // 'Maghrib':1,
                          'Isha':0,

                        });
                      }
                      else{
                        DocumentReference collection6 = FirebaseFirestore.instance
                            .collection("history").doc(uid)
                            .collection('allNamaz')
                            .doc(getDateOfToday());
                        collection6.update({
                          // 'name': widget.nameOfTheNamaz,
                          // 'time': widget.timeOfTheNamaz,
                          // widget.nameOfTheNamaz : 1,
                          // 'Fajar':1,
                          // 'Zohar':1,
                          // 'Asar':1,
                          // 'Maghrib':1,
                          'Isha': 1,

                        });
                      }
                      if (widget.namazStatus.value == true) {
                        snackShow();
                      }
                    }
                    if (widget.nameOfTheNamaz == "Witr") {
                      widget.namazStatus.value = v!;
                      _todayQazaController.witrStatus.value =
                          widget.namazStatus.value;
                      if(v == true){
                        DocumentReference collection6 = FirebaseFirestore.instance
                            .collection("history").doc(uid)
                            .collection('allNamaz')
                            .doc(getDateOfToday());
                        collection6.update({
                          // 'name': widget.nameOfTheNamaz,
                          // 'time': widget.timeOfTheNamaz,
                          // widget.nameOfTheNamaz : 1,
                          // 'Fajar':0,
                          // 'Zohar':1,
                          // 'Asar':1,
                          // 'Maghrib':1,
                          // 'Isha':0,
                          'Witr' : 0

                        });
                      }
                      else{
                        DocumentReference collection6 = FirebaseFirestore.instance
                            .collection("history").doc(uid)
                            .collection('allNamaz')
                            .doc(getDateOfToday());
                        collection6.update({
                          // 'name': widget.nameOfTheNamaz,
                          // 'time': widget.timeOfTheNamaz,
                          // widget.nameOfTheNamaz : 1,
                          // 'Fajar':1,
                          // 'Zohar':1,
                          // 'Asar':1,
                          // 'Maghrib':1,
                          // 'Isha': 1,
                          'Witr' : 1

                        });
                      }
                      if (widget.namazStatus.value == true) {
                        snackShow();
                      }
                    }

                    //We have Done Some Changes Here DevSol360
                    DocumentReference collections5 = FirebaseFirestore.instance
                        .collection('namaz')
                        .doc(uid)
                        .collection('today')
                        .doc(widget.nameOfTheNamaz);

                    collections5.set({
                      'name': widget.nameOfTheNamaz,
                      'time': widget.timeOfTheNamaz,
                      'status': widget.namazStatus.value
                    });
                  });


                })),
            Gap(3.w)
          ],
        ),
      ),
    );
  }

  String getDateOfToday() {
    var date = DateTime.now().toString();
    var dateparse = DateTime.parse(date);
    var formattedDate = "${dateparse.day}-${dateparse.month}-${dateparse.year}";
    return formattedDate.toString();
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
        Icons.thumb_up,
        color: Colors.white,
      ),
      mainButton: InkWell(
        onTap: () {},
        child: const Text(
          "",
          style: TextStyle(color: Colors.amber),
        ),
      ),
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.black,
      titleText: Text(
        AppLocalizations.of(context)!.great,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Colors.yellow[600],
            fontFamily: "ShadowsIntoLightTwo"),
      ),
      messageText: Text(
        "${widget.nameOfTheNamaz} ${AppLocalizations.of(context)!.prayerIsDoneCheckDashboard}",
        style: const TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontFamily: "ShadowsIntoLightTwo"),
      ),
    ).show(context);
  }
}