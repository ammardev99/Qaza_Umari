import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qaza_e_umri/core/controller/today_qaza_controller.dart';
import 'package:qaza_e_umri/core/services/notification_services.dart';
import 'package:qaza_e_umri/constants/assets_path.dart';
import 'package:qaza_e_umri/main.dart';
import 'package:qaza_e_umri/ui/screens/inner_screen/daily_prayer.dart';
import 'package:qaza_e_umri/ui/screens/inner_screen/dashboard/dashboard.dart';
import 'package:qaza_e_umri/ui/screens/homepage/menu.dart';
import 'package:qaza_e_umri/ui/screens/month_end.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/app_constants.dart';
import '../inner_screen/support/support.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  NotificationServices notificationServices = NotificationServices();
  bool? boolValue = true;

  //${Get.put(TodayQazaController()).fjrQaza.value}
  var month = DateTime.now().month.toString().length == 1
      ? "0${DateTime.now().month}"
      : DateTime.now().month;
  var day = DateTime.now().day.toString().length == 1
      ? "0${DateTime.now().day}"
      : DateTime.now().day;

  @override
  void initState() {
    super.initState();
    getBoolValuesSF();
  }

  getBoolValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Future.delayed(const Duration(seconds: 2), () {
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
    return boolValue;
  }

  addBoolToSF() async {
    if (boolValue == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('boolValue', false);

      setState(() {
        boolValue = false;
      });
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('boolValue', true);

      setState(() {
        boolValue = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: const DrawerMenu(),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  //color: Colors.black87, // Change Custom Drawer Icon Color
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          actions: [
            boolValue == false
                ? IconButton(
                    icon: const Icon(Icons.notifications_off),
                    onPressed: () async {
                      setState(() {
                        addBoolToSF();
                        getBoolValuesSF();
                      });
                    },
                  )
                : IconButton(
                    icon: const Icon(mNotificationIcon),
                    onPressed: () async {
                      setState(() {
                        addBoolToSF();
                        getBoolValuesSF();
                      });
                    },
                  ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MonthEndTest()),
                        );
                      },
                      icon: Icon(
                        Icons.nearby_error,
                        color: Colors.red,
                      ),
                    ),
          ],
          //backgroundColor: Colors.purple,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [colorsGreen, colorsGreen],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          ),
          bottom: TabBar(
            //isScrollable: true,
            indicatorColor: Colors.white,
            indicatorWeight: 5,
            tabs: [
              Tab(icon: Icon(Icons.lock_clock), text: AppLocalizations.of(context)!.dailyPrayer),
              Tab(icon: Icon(Icons.dashboard), text: AppLocalizations.of(context)!.dashboard),
              Tab(icon: Icon(Icons.handshake), text: AppLocalizations.of(context)!.support),
              // Tab(icon: Icon(Icons.history), text: AppLocalizations.of(context)!.history),
            ],
          ),
          elevation: 20,
          titleSpacing: 20,
        ),
        body: TabBarView(
          children: [
            DailyPrayer(),
            Dashboard(),
            SupportPage(),
            // HistoryScreen(),
          ],
        ),
      ),
    );
  }

  // Widget buildPage(String text) => Center(
  //       child: Text(
  //         text,
  //         style: TextStyle(fontSize: 28),
  //       ),
  //     );
}
