import 'package:flutter/material.dart';
import 'package:qaza_e_umri/ui/screens/inner_screen/dashboard/bottom_nav.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardPageNav(
      title: '',
    );
  }
}

class DashboardPageNav extends StatefulWidget {
  final String title;

  const DashboardPageNav({
    super.key,
    required this.title,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DashboardPageNavState createState() => _DashboardPageNavState();
}

class _DashboardPageNavState extends State<DashboardPageNav> {
  @override
  Widget build(BuildContext context) => const Scaffold(
        body: BottomNav(),
      );
}
