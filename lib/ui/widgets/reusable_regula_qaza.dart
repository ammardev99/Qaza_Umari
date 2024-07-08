import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:qaza_e_umri/core/controller/today_controller.dart';
import 'package:qaza_e_umri/constants/app_constants.dart';
import 'package:qaza_e_umri/constants/assets_path.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ignore: must_be_immutable
class ReusableRegularQaza extends StatefulWidget {
  final String nameOfTheNamaz;
  String dateOfTheNamaz;
  String timeOfTheNamaz;
  RxBool namazStatus;
  ReusableRegularQaza(
      {super.key,
      required this.nameOfTheNamaz,
      required this.timeOfTheNamaz,
      required this.dateOfTheNamaz,
      required this.namazStatus});

  @override
  State<ReusableRegularQaza> createState() => _ReusableRegularQazaState();
}

class _ReusableRegularQazaState extends State<ReusableRegularQaza> {
  TextEditingController timeinput = TextEditingController();

  final _todayController = Get.put(TodayController());
  final double faj = 0;
  final double zoher = 0;
  final double asar = 0;
  final double magrib = 0;
  final double aysha = 0;

  @override
  void initState() {
    super.initState();
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
                    .dateOfTheNamaz, //editing controller of this TextField
              decoration: const InputDecoration(
                border: InputBorder.none,
                icon: Icon(
                  calendarIcon,
                  color: Colors.black,
                ), //icon of text field
                //labelText: "Enter Time" //label text of field
              ),
              readOnly:
                  true, //set it true, so that user will not able to edit text
              // onTap: () async {
              //   TimeOfDay? pickedTime = await showTimePicker(
              //     initialTime: TimeOfDay.now(),
              //     context: context,
              //   );

              //   if (pickedTime != null) {
              //     // print(pickedTime.format(context));   //output 10:51 PM
              //     // DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
              //     // //converting to DateTime so that we can further format on different pattern.
              //     // print(parsedTime); //output 1970-01-01 22:53:00.000
              //     // String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
              //     // print(formattedTime); //output 14:59:00
              //     //DateFormat() is from intl package, you can format the time on any pattern you need.
              //     String a = pickedTime.format(context);

              //     setState(() {
              //       timeinput.text = a; //set the value of text field.
              //       widget.dateOfTheNamaz = a;

              //       DocumentReference collections5 = FirebaseFirestore.instance
              //           .collection('namaz')
              //           .doc(uid)
              //           .collection('today')
              //           .doc(widget.nameOfTheNamaz);

              //       collections5.set({
              //         'name': widget.nameOfTheNamaz,
              //         'time': a,
              //         'status': widget.namazStatus.value
              //       });
              //     });
              //   } else {
              //     print("Time is not selected");
              //   }
              // },
            ))),
            Gap(9.w),
            Checkbox(
                checkColor: Colors.white,
                activeColor: Colors.green,
                value: widget.namazStatus.value,
                onChanged: ((v) {
                  setState(() {
                        
               
                    if (widget.nameOfTheNamaz == "Zohar") {
                      _todayController.zhrStatus.value =
                          widget.namazStatus.value;
                      if (widget.namazStatus.value == true) {
                        snackShow();
                      }
                    }
                    if (widget.nameOfTheNamaz == "Asar") {
                      _todayController.asrStatus.value =
                          widget.namazStatus.value;
                      if (widget.namazStatus.value == true) {
                        snackShow();
                      }
                    }
                    if (widget.nameOfTheNamaz == "Maghrib") {
                      _todayController.mgrbStatus.value =
                          widget.namazStatus.value;
                      if (widget.namazStatus.value == true) {
                        snackShow();
                      }
                    }
                    if (widget.nameOfTheNamaz == "Isha") {
                      _todayController.ishaStatus.value =
                          widget.namazStatus.value;
                      if (widget.namazStatus.value == true) {
                        snackShow();
                      }
                    }
                    if (widget.nameOfTheNamaz == "Witr") {
                      _todayController.witrStatus.value =
                          widget.namazStatus.value;
                      if (widget.namazStatus.value == true) {
                        snackShow();
                      }
                    }
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
                    _todayController.asrStatus.value =
                        widget.namazStatus.value;
                    // new collection // 
                    // DocumentReference collection6 = FirebaseFirestore.instance
                    // .collection("namaz").doc(uid)
                    // .collection('history')
                    // .doc(getDateOfToday());
                    //    collection6 .set({
                    //   'name': widget.nameOfTheNamaz,
                    //   'time': widget.timeOfTheNamaz,
                    //   'status': widget.namazStatus.value,
                    //   'date':getDateOfToday(),









                    //We have Done Some Changes Here DevSol360


                    if(widget.namazStatus.value == false){
                      print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<object>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
                      DocumentReference collection6 = FirebaseFirestore.instance
                          .collection("namaz").doc(uid)
                          .collection('history')
                          .doc(getDateOfToday());
                      collection6.set({
                        'name': widget.nameOfTheNamaz,
                        'time': widget.timeOfTheNamaz,
                        'status': 1,
                      });
                    }else{
                      print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<object>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>1111111111111111111111111");

                      DocumentReference collection6 = FirebaseFirestore.instance
                          .collection("namaz").doc(uid)
                          .collection('history')
                          .doc(getDateOfToday()).collection(widget.nameOfTheNamaz).doc(widget.nameOfTheNamaz);
                      collection6.set({
                        'name': widget.nameOfTheNamaz,
                        'time': widget.timeOfTheNamaz,
                        'status': 0,
                      });
                    }
                  });
                })),
            Gap(3.w)
          ],
        ),
      ),
    );
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
        "${widget.nameOfTheNamaz} ${AppLocalizations.of(context)!.prayerIsDone}",
        style: const TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontFamily: "ShadowsIntoLightTwo"),
      ),
    ).show(context);
  }
    String getDateOfToday() {
    var date = DateTime.now().toString();
    var dateparse = DateTime.parse(date);
    var formattedDate = "${dateparse.day}-${dateparse.month}-${dateparse.year}";
    return formattedDate.toString();
  }
}
