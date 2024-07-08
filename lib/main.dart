import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qaza_e_umri/core/controller/notification_controller.dart';
import 'package:qaza_e_umri/core/provider/auth_provider.dart';
import 'package:qaza_e_umri/ui/screens/login_screen.dart';
import 'package:qaza_e_umri/ui/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'constants/route_name.dart';
import 'core/provider/language_change_controller.dart';
import 'ui/screens/homepage/home.dart';
import 'ui/screens/homepage/welcome_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
// ignore: unused_import
import 'dart:math' as math;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

int? isViewed;
bool fjrSta = false;

int d = 0;
int m = 0;
int y = 0;

// ignore: prefer_typing_uninitialized_variables
var scheduleTime;
var title = [
  'Fajar Prayer Time',
  'Zohar Prayer Time',
  'Asar Prayer Time',
  'Maghrib Prayer Time',
  'Isha Prayer Time',
  'Prayer done?'
];
var note = [
  'Remember to offer qaza-e-umri namaz too.',
  'Remember to offer qaza-e-umri namaz too.',
  'Remember to offer qaza-e-umri namaz too.',
  'Remember to offer qaza-e-umri namaz too.',
  'Remember to offer qaza-e-umri namaz too.',
  'If not, pray qaza then mark all and submit to get next day reminder.'
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationApi.init();
  tz.initializeTimeZones();
  // MobileAds.instance.initialize();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SharedPreferences preferences = await SharedPreferences.getInstance();
  final String languageCode = preferences.getString("language_code") ?? "en";
  print(languageCode);

  isViewed = preferences.getInt('welcome_screen');

  runApp(MyApp(locale: languageCode,));
}

class MyApp extends StatelessWidget {
  final String locale;
  const MyApp({Key? key, required this.locale}) : super(key: key);
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String name = 'Awesome Notifications - Example App';
  static const Color mainColor = Colors.deepPurple;

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return MultiProvider(
                providers: [
                  ///will put other providers here.........
                  ChangeNotifierProvider(create: (_) => AuthProviderAuth()),
                  ChangeNotifierProvider(create: (_) => LanguageController()),
                ],
                child: Consumer<LanguageController>(
                  builder: (context, provider,child){
                    if(locale.isEmpty){
                      provider.ChangeLanguage(Locale("en"));
                    }
                    return MaterialApp(
                      locale: locale ==""?Locale("en") :  provider.appLocale == null ? Locale(locale) : provider.appLocale,
                      localizationsDelegates: [
                        AppLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                      ],
                      supportedLocales: [
                        Locale('en'),
                        Locale('ur'),
                      ],
                      navigatorKey: MyApp.navigatorKey,
                      title: MyApp.name,
                      color: MyApp.mainColor,
                      debugShowCheckedModeBanner: false,
                      routes: {
                        RouteName.splashScreen: (contex) => const SplashScreen(),
                        RouteName.loginScreen: (contex) => const LoginScreen(),
                        RouteName.mainScreen: (contex) =>
                        isViewed != 0 ? const WelcomeScreen() : const Home(),
                      },
                    );
                  },
                )
              );
            } else if (snapshot.hasError) {
              return const MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  body: Center(child: Text('Something went wrong :(')),
                ),
              );
            }
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                    child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                )),
              ),
            );
          });
    });
  }
}
