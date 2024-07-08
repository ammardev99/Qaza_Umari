import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:qaza_e_umri/core/controller/today_qaza_controller.dart';
import 'package:qaza_e_umri/constants/assets_path.dart';
import 'package:qaza_e_umri/main.dart';
import 'package:qaza_e_umri/ui/widgets/reusable_regula_qaza.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../constants/app_constants.dart';

class RegularQaza extends StatefulWidget {
  const RegularQaza({super.key});

  @override
  State<RegularQaza> createState() => _RegularQazaState();
}

class _RegularQazaState extends State<RegularQaza> {
  String today = '';
  String all = '';
  final TodayQazaController _todayQazaController =
      Get.put(TodayQazaController());
  bool isToday = false;

  int presentHour = DateTime.now().hour;

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
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!.regularQazaRecord,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),

                      // Gap(.4.h),
                      // Text(getDateOfToday()),
                     const SizedBox(
                        height: 10,
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
                  // ignore: unrelated_type_equality_checks
                  () => _todayQazaController.fjrStatus == true ||
                          presentHour <
                              (int.parse(_todayQazaController.fjrQaza.value) +
                                  3)
                      ? Container()
                      : ReusableRegularQaza(
                          nameOfTheNamaz: AppLocalizations.of(context)!.fajar,
                          timeOfTheNamaz: _todayQazaController.fjrTime.value,
                          dateOfTheNamaz: getDateOfToday(),
                          namazStatus: _todayQazaController.fjrStatus,
                        ),
                ),
                Obx(
                  // ignore: unrelated_type_equality_checks
                  () => _todayQazaController.zhrStatus == true ||
                          presentHour <
                              (int.parse(_todayQazaController.zhrQaza.value) +
                                  12 +
                                  3)
                      ? Container()
                      : ReusableRegularQaza(
                          nameOfTheNamaz: AppLocalizations.of(context)!.zohar,
                          timeOfTheNamaz: _todayQazaController.zhrTime.value,
                          dateOfTheNamaz: getDateOfToday(),
                          namazStatus: _todayQazaController.zhrStatus,
                        ),
                ),
                Obx(
                  // ignore: unrelated_type_equality_checks
                  () => _todayQazaController.asrStatus == true ||
                          presentHour <
                              (int.parse(_todayQazaController.asrQaza.value) +
                                  12 +
                                  2)
                      ? Container()
                      : ReusableRegularQaza(
                          nameOfTheNamaz: AppLocalizations.of(context)!.asar,
                          timeOfTheNamaz: _todayQazaController.asrTime.value,
                          dateOfTheNamaz: getDateOfToday(),
                          namazStatus: _todayQazaController.asrStatus,
                        ),
                ),
                Obx(
                  // ignore: unrelated_type_equality_checks
                  () => _todayQazaController.mgrbStatus == true ||
                          presentHour <
                              (int.parse(_todayQazaController.mgrbQaza.value) +
                                  12 +
                                  1)
                      ? Container()
                      : ReusableRegularQaza(
                          nameOfTheNamaz: AppLocalizations.of(context)!.maghrib,
                          timeOfTheNamaz: _todayQazaController.mgrbTime.value,
                          dateOfTheNamaz: getDateOfToday(),
                          namazStatus: _todayQazaController.mgrbStatus,
                        ),
                ),
                Obx(
                  // ignore: unrelated_type_equality_checks
                  () => _todayQazaController.ishaStatus == true ||
                          presentHour <
                              (int.parse(_todayQazaController.ishaQaza.value) +
                                  12 +
                                  3)
                      ? Container()
                      : ReusableRegularQaza(
                          nameOfTheNamaz: AppLocalizations.of(context)!.isha,
                          timeOfTheNamaz: _todayQazaController.ishaTime.value,
                          dateOfTheNamaz: getDateOfToday(),
                          namazStatus: _todayQazaController.ishaStatus,
                        ),
                ),
                Obx(
                  // ignore: unrelated_type_equality_checks
                  () => _todayQazaController.witrStatus == true ||
                          presentHour <
                              (int.parse(_todayQazaController.witrQaza.value) +
                                  12 +
                                  3)
                      ? Container()
                      : ReusableRegularQaza(
                          nameOfTheNamaz: AppLocalizations.of(context)!.witr,
                          timeOfTheNamaz: _todayQazaController.witrTime.value,
                          dateOfTheNamaz: getDateOfToday(),
                          namazStatus: _todayQazaController.witrStatus,
                        ),
                ),
              ],
            ),
          )
        : Column(
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
                          AppLocalizations.of(context)!.regularQazaRecord,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
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
              const Spacer(),
              Image.asset(
                'assets/images/done.png',
                scale: 3,
              ),
              const SizedBox(
                height: 20,
              ),
               Text(
                AppLocalizations.of(context)!.noQazaToday,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
              const Spacer(),
            ],
          );
  }

  String getDateOfToday() {
    var date = DateTime.now().toString();
    var dateparse = DateTime.parse(date);
    var formattedDate = "${dateparse.day}-${dateparse.month}-${dateparse.year}";
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
      _todayQazaController.fjrStatus.value = false;
      _todayQazaController.zhrStatus.value = false;
      _todayQazaController.asrStatus.value = false;
      _todayQazaController.mgrbStatus.value = false;
      _todayQazaController.ishaStatus.value = false;
      _todayQazaController.witrStatus.value = false;
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

  void infoDialog() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.learnAboutRegularQaza,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF000000)),
            ),
            content: Text(
              AppLocalizations.of(context)!.thisIsDayToDayQazaRecord
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
}
