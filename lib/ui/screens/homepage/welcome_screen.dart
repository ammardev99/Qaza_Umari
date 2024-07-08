import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qaza_e_umri/constants/app_constants.dart';
import 'package:qaza_e_umri/ui/screens/homepage/home.dart';
import 'package:qaza_e_umri/core/models/welcome_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/firebase.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  List<SliderModel> slides = <SliderModel>[];
  int currentIndex = 0;
  PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    // TODO: implement initState
    dataExist();
    super.initState();
    slides = getSlides(context);
  }

  storeWelcomeScreenInfo() async {
    int isViewed = 0;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt('welcome_screen', isViewed);
  }

  Widget pageIndexIndicator(bool isCurrentPage) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
          color: isCurrentPage ? Colors.grey : Colors.grey[300],
          borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    storeWelcomeScreenInfo();
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
          controller: pageController,
          itemCount: slides.length,
          onPageChanged: (val) {
            setState(() {
              currentIndex = val;
            });
          },
          itemBuilder: (context, index) {
            return SliderTile(
              imageAssetPath: slides[index].getImageAssetPath(),
              title: slides[index].getTitle(),
              desc: slides[index].getdesc(),
            );
          }),
      bottomSheet: currentIndex != slides.length - 1
          ? Container(
              height: Platform.isIOS ? 70 : 60,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        pageController.animateToPage(slides.length - 1,
                            duration: const Duration(microseconds: 400),
                            curve: Curves.linear);
                      },
                      // child:  Text(AppLocalizations.of(context)!.skip)
                        child:  Text("SKIP")
                      ),
                  Row(
                    children: <Widget>[
                      for (int i = 0; i < slides.length; i++)
                        currentIndex == i
                            ? pageIndexIndicator(true)
                            : pageIndexIndicator(false)
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      pageController.animateToPage(currentIndex + 1,
                          duration: const Duration(microseconds: 400),
                          curve: Curves.linear);
                    },
                    // child:  Text(AppLocalizations.of(context)!.next),
                     child:  Text("NEXT")
                  ),
                ],
              ),
            )
          : GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return const Home();
                  },
                ));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: Platform.isIOS ? 60 : 50,
                  color: colorsGreen,
                  child:  InkWell(
                    child: Text(
                      // AppLocalizations.of(context)!.getStarted,
                       ("GET STARTED"),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> dataExist() async {
    final User user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('namaz')
        .doc(user.uid)
        .get()
        .then((ds) {
      if (ds.data() == null) {
        today();
      } else {
        today();
      }
    });
  }
}

// ignore: must_be_immutable
class SliderTile extends StatelessWidget {
  String imageAssetPath, title, desc;
  SliderTile(
      {super.key,
      required this.imageAssetPath,
      required this.title,
      required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(imageAssetPath),
          const SizedBox(
            height: 20,
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
