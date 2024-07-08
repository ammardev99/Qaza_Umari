import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:qaza_e_umri/constants/app_constants.dart';
import 'package:qaza_e_umri/core/controller/qasar_qaza_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class ReusableQasarQaza extends StatefulWidget {
  final String nameOfTheNamaz;
  int totalNamaz;
  ReusableQasarQaza({
    super.key,
    required this.nameOfTheNamaz,
    required this.totalNamaz,
  });

  @override
  State<ReusableQasarQaza> createState() => _ReusableQasarQazaState();
}

class _ReusableQasarQazaState extends State<ReusableQasarQaza> {
  TextEditingController timeinput = TextEditingController();

  final QasarQazaController _qasarQazaController =
      Get.put(QasarQazaController());

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
                ..text = widget.totalNamaz
                    .toString(), //editing controller of this TextField
              decoration: const InputDecoration(
                border: InputBorder.none,
                icon: Icon(
                  Icons.calculate,
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
            InkWell(
                onTap: () {
                  if (widget.nameOfTheNamaz == "Fajar" &&
                      widget.totalNamaz != 0) {
                    _qasarQazaController.fjrTotal.value = widget.totalNamaz - 1;
                    DocumentReference collections = FirebaseFirestore.instance
                        .collection('namaz')
                        .doc(uid)
                        .collection('qasar')
                        .doc('Fajar');

                    collections
                        .update({'total': _qasarQazaController.fjrTotal.value});
                    snackShow();
                  } else if (widget.nameOfTheNamaz == "Zohar" &&
                      widget.totalNamaz != 0) {
                    _qasarQazaController.zhrTotal.value = widget.totalNamaz - 1;
                    DocumentReference collections2 = FirebaseFirestore.instance
                        .collection('namaz')
                        .doc(uid)
                        .collection('qasar')
                        .doc('Zohar');

                    collections2
                        .update({'total': _qasarQazaController.zhrTotal.value});
                    snackShow();
                  } else if (widget.nameOfTheNamaz == "Asar" &&
                      widget.totalNamaz != 0) {
                    _qasarQazaController.asrTotal.value = widget.totalNamaz - 1;
                    DocumentReference collections3 = FirebaseFirestore.instance
                        .collection('namaz')
                        .doc(uid)
                        .collection('qasar')
                        .doc('Asar');

                    collections3
                        .update({'total': _qasarQazaController.asrTotal.value});
                    snackShow();
                  } else if (widget.nameOfTheNamaz == "Maghrib" &&
                      widget.totalNamaz != 0) {
                    _qasarQazaController.mgrbTotal.value =
                        widget.totalNamaz - 1;
                    DocumentReference collections4 = FirebaseFirestore.instance
                        .collection('namaz')
                        .doc(uid)
                        .collection('qasar')
                        .doc('Maghrib');

                    collections4.update(
                        {'total': _qasarQazaController.mgrbTotal.value});

                    snackShow();
                  } else if (widget.nameOfTheNamaz == "Isha" &&
                      widget.totalNamaz != 0) {
                    _qasarQazaController.ishaTotal.value =
                        widget.totalNamaz - 1;
                    DocumentReference collections5 = FirebaseFirestore.instance
                        .collection('namaz')
                        .doc(uid)
                        .collection('qasar')
                        .doc('Isha');

                    collections5.update(
                        {'total': _qasarQazaController.ishaTotal.value});

                    snackShow();
                  } else if (widget.nameOfTheNamaz == "Witr" &&
                      widget.totalNamaz != 0) {
                    _qasarQazaController.witrTotal.value =
                        widget.totalNamaz - 1;
                    DocumentReference collections6 = FirebaseFirestore.instance
                        .collection('namaz')
                        .doc(uid)
                        .collection('qasar')
                        .doc('Witr');

                    collections6.update(
                        {'total': _qasarQazaController.witrTotal.value});

                    snackShow();
                  }
                },
                child: Card(
                  color: colorsGreen,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: colorsGreen, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 13, right: 13, top: 8, bottom: 8),
                    child: Text(
                      AppLocalizations.of(context)!.offered,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )),
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
        "${widget.nameOfTheNamaz} ${AppLocalizations.of(context)!.recordHasBeenAddedSuccessfully}",
        style: const TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontFamily: "ShadowsIntoLightTwo"),
      ),
    ).show(context);
  }
}
