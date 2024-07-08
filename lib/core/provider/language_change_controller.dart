import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController with ChangeNotifier {
  Locale? _appLocale;

  Locale? get appLocale => _appLocale;

  void ChangeLanguage(Locale languageCode) async {
    print("The Language Code is $languageCode");
    _appLocale = languageCode;
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (languageCode.toString() == "en") {
      await sp.setString("language_code", "en");
      print("The Language is English");
    } else {
      await sp.setString("language_code", "ur");
      print("The Language is Urdu");

    }
    notifyListeners();
  }
}
