import 'package:flutter/material.dart';
import 'package:qaza_e_umri/constants/app_constants.dart';
import 'package:qaza_e_umri/ui/screens/history/history.dart';
import 'package:qaza_e_umri/ui/screens/inner_screen/dashboard/qasar_qaza.dart';
import 'package:qaza_e_umri/ui/screens/inner_screen/dashboard/qaza_umri.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: Container(
          color: const Color(0xFFe6e6e6),
          child: TabBar(
            //isScrollable: true,
            indicator: BoxDecoration(
              color: colorsGreen,
              border: Border(
                top: BorderSide(color: colorsGreen),
              ),
            ),
            indicatorWeight: 5,
            tabs: [
              Tab(text: AppLocalizations.of(context)!.history),
              Tab(text: AppLocalizations.of(context)!.qazaUmri),
              Tab(text: AppLocalizations.of(context)!.qasarQaza),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: colorsGreen,
          ),
        ),
        body: const TabBarView(
          children: [HistoryScreen(), QazaUmri(), QasarQaza(),],
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
