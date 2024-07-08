import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qaza_e_umri/constants/app_constants.dart';
import 'package:qaza_e_umri/constants/assets_path.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  List<DocumentSnapshot> documents = [];
  String sTitle = '';
  String sDescription = '';

  AdRequest? adRequest;
  BannerAd? bannerAd;

  bool _isRewardedAdReady = false;

  RewardedAd? _rewardedAd;

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
    _loadBanner();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
        _rewardedAd = ad;
        ad.fullScreenContentCallback =
            FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
          _isRewardedAdReady = false;
          _loadRewardedAd();
        });
        _isRewardedAdReady = true;
      }, onAdFailedToLoad: (error) {
        //print('Failed to load a rewarded ad: ${error.message}');
        _isRewardedAdReady = false;
      }),
    );
  }

  void _loadBanner() {
    adRequest = const AdRequest(
      nonPersonalizedAds: false,
    );

    BannerAdListener bannerAdListener = BannerAdListener(
      onAdClosed: (ad) {
        bannerAd!.load();
      },
      onAdFailedToLoad: (ad, error) {
        bannerAd!.load();
      },
    );
    bannerAd = BannerAd(
      size: AdSize.largeBanner,
      adUnitId: bannerAdUnitId,
      listener: bannerAdListener,
      request: adRequest!,
    );

    bannerAd!.load();
  }

  @override
  void dispose() {
    bannerAd!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFFFFFFFF)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(2.h),
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
                      AppLocalizations.of(context)!.supportPage,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                    // Gap(.4.h),
                    // Text(getDateOfToday()),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("support").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                documents = snapshot.data!.docs;
                return ListView(
                  children: documents.map((document) {
                    sTitle = document['title'];
                    sDescription =
                        document['description'].replaceAll('\\n', '\n');
                    return InkWell(
                      onTap: (() {
                        sTitle = document['title'];
                        sDescription =
                            document['description'].replaceAll('\\n', '\n');
                        infoDialog();
                      }),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                            height: 5.7.h,
                            decoration: BoxDecoration(
                              color: const Color(0xffE8E9EB),
                              borderRadius: BorderRadius.circular(
                                  5.0), // Adjust the value for roundness
                            ),
                            child: Row(
                              children: [
                                Gap(3.w),
                                Text(sTitle,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                const Spacer(),
                                const Icon(
                                  mInfoIcon,
                                  color: colorsGreen,
                                ),
                                Gap(3.w),
                              ],
                            )),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Gap(2.h),
          if (bannerAd != null)
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: bannerAd!.size.width.toDouble(),
                height: bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: bannerAd!),
              ),
            ),
        ],
      ),
    );
  }

  void infoDialog() {
    showDialog(
        context: context,
        builder: (ctx) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: colorsGreen,
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if (_isRewardedAdReady) {
                      _rewardedAd?.show(
                        onUserEarnedReward: (_, reward) {
                          // QuizManager.instance.useHint();
                        },
                      );
                    }
                    Navigator.of(context).pop();
                  }),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Text(
                        sTitle,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF000000),
                            fontSize: 17),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Text(
                        sDescription,
                        style: const TextStyle(
                            color: Color(0xFF000000), fontSize: 17),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
