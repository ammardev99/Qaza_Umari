import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qaza_e_umri/ui/screens/homepage/nav_bar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainPageNav(
      title: '',
    );
  }
}

class MainPageNav extends StatefulWidget {
  final String title;

  const MainPageNav({
    super.key,
    required this.title,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MainPageNavState createState() => _MainPageNavState();
}

class _MainPageNavState extends State<MainPageNav> {
  InterstitialAd? _interstitialAd;

  // @override
  // void initState() {
  //   super.initState();
  //   _loadInterstitialAd();
  //   Future.delayed(const Duration(seconds: 7), () {
  //     setState(() {
  //       _showInterstitialAd();
  //     });
  //   });
  // }

  // void _loadInterstitialAd() {
  //   InterstitialAd.load(
  //     adUnitId: interstitialAdUnitId,
  //     request: const AdRequest(),
  //     adLoadCallback: InterstitialAdLoadCallback(
  //       onAdLoaded: (InterstitialAd ad) {
  //         _interstitialAd = ad;
  //       },
  //       onAdFailedToLoad: (LoadAdError error) {
  //         //print('Interstitial ad failed to load: $error');
  //       },
  //     ),
  //   );
  // }

  // void _showInterstitialAd() {
  //   if (_interstitialAd == null) {
  //     //print('Interstitial ad not loaded yet');
  //     return;
  //   }
  //
  //   _interstitialAd!.show();
  // }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: NavBar(),
    );
  }
}
