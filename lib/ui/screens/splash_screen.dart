import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:qaza_e_umri/core/provider/auth_check_for_splash.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  SplashServices splashServices = SplashServices();

  @override
  Widget build(BuildContext context) {
    splashServices.checkAuthentication(context);

    return Scaffold(
      //backgroundColor: Colors.cyan[800],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SafeArea(
            child: SizedBox(
              width: 385,
              height: 220,
              child: Image.asset('assets/images/icon.png'),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Center(
              child: Text(
            AppLocalizations.of(context)!.qazaEUmri,
            style: TextStyle(color: Colors.black, fontSize: 20),
          )),
          Gap(35.h),
          const SpinKitThreeBounce(
            size: 40,
            color: Colors.green,
          ),
          const SizedBox(
            height: 30,
          ),
           Center(
              child: Text(
            AppLocalizations.of(context)!.allRightsReserved,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          )),
           Center(
            child: Text(
              AppLocalizations.of(context)!.irfanUlQuran,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
