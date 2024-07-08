import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qaza_e_umri/core/provider/auth_provider.dart';
import 'package:qaza_e_umri/constants/route_name.dart';

class SplashServices {
  void checkAuthentication(BuildContext context) async {
    final authViewModel = Provider.of<AuthProviderAuth>(context, listen: false);
    bool? loginCheck = authViewModel.isLoggedIn;

    if (loginCheck) {
      Future.delayed(const Duration(seconds: 3)).then((value) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(RouteName.mainScreen, (route) => false);
        
      });
    } else {
      Timer(Duration(seconds: 3), () {
        Navigator.pushNamedAndRemoveUntil(
                    context, RouteName.loginScreen, (route) => false);
      });
      // await Future.delayed(const Duration(seconds: 3)).then((value) =>
      //     Navigator.pushNamedAndRemoveUntil(
      //         context, RouteName.loginScreen, (route) => false));
    }
  }
}
