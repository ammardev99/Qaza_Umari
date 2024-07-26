import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_validator/form_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'package:qaza_e_umri/constants/route_name.dart';
import 'package:qaza_e_umri/ui/screens/homepage/home.dart';
import 'package:qaza_e_umri/ui/screens/inner_screen/forgot.dart';
import 'package:qaza_e_umri/ui/screens/inner_screen/signUp.dart';
import 'package:qaza_e_umri/ui/widgets/reusble_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/provider/auth_provider.dart';
import 'homepage/menu.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  bool loadingForFacebookLoginOnAuth = false;
  bool loadingForGoogleLoginOnAuth = false;
  String? email;
  String? password;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProviderAuth>(context);
    // final provider = Provider.of<AuthProvider>(context);
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: Form(
        key: key,
        child: SizedBox(
          width: double.infinity,
          // decoration: const BoxDecoration(
          //     gradient:
          //         LinearGradient(begin: Alignment.topCenter, colors: [
          //   Color(0xFFFEAC5E),
          //   Color(0xFFC779D0),
          //   Color(0xFF4BC0C8),
          // ])),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.06),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: h * 0.02,
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      child: Image.asset(
                        'assets/images/icon.png',
                        scale: 3,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Center(
                            child: Text(
                          AppLocalizations.of(context)!.signIn,
                          style: TextStyle(color: Colors.black, fontSize: 35),
                        )),
                        const SizedBox(
                          height: 20,
                        ),
                        //
                        SizedBox(
                          height: 55,
                          width: MediaQuery.of(context).size.width * .96,
                          child: TextFormField(
                            validator: ValidationBuilder()
                                .email()
                                .maxLength(50)
                                .build(),
                            onChanged: (value) {
                              email = value;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                labelText:
                                    AppLocalizations.of(context)!.enterEmail,
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Colors.green,
                                )),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 55,
                          width: MediaQuery.of(context).size.width * .96,
                          child: TextFormField(
                            validator: ValidationBuilder()
                                .maxLength(12)
                                .minLength(6)
                                .build(),
                            onChanged: (value) {
                              password = value;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                labelText:
                                    AppLocalizations.of(context)!.enterPassword,
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Colors.green,
                                )),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                              onTap: () => Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const ForgotPassword();
                                  })),
                              child: Text(
                                AppLocalizations.of(context)!.forgotPassword,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.green),
                              )),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Rounded_Button(
                          loading: isLoading,
                          ontap: () async {
                            if (key.currentState?.validate() ?? false) {
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: email!, password: password!)
                                    .then((value) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const Home();
                                  }));
                                });

                                // AuthProvider.emailAuth(email!, password!).then((value) =>const Dashboard());
                                setState(() {
                                  isLoading = false;
                                });
                              } on FirebaseAuthException catch (e) {
                                setState(() {
                                  isLoading = false;
                                });
                                if (e.code == 'wrong-password') {
                                  throw (AppLocalizations.of(context)!
                                      .thePasswordProvidedIsWrong);
                                }
                              } catch (e) {
                                setState(() {
                                  isLoading = false;
                                });
                                print(e.toString());
                              }
                            }
                          },
                          title: AppLocalizations.of(context)!.signIn,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const SignUpPage();
                                    }));
                                  },
                                  child: Text(
                                    "don't have an account! " +
                                        AppLocalizations.of(context)!.register,
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 16),
                                  ))),
                        ),
                        //
                        Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.black),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                loadingForGoogleLoginOnAuth = true;
                              });
                              try {
                                final GoogleSignInAccount? googleUser =
                                    await _googleSignIn.signIn();
                                if (googleUser == null) {
                                  return null; // The user canceled the sign-in
                                }
                                final GoogleSignInAuthentication googleAuth =
                                    await googleUser.authentication;
                                final AuthCredential credential =
                                    GoogleAuthProvider.credential(
                                  accessToken: googleAuth.accessToken,
                                  idToken: googleAuth.idToken,
                                );

                                final UserCredential userCredential =
                                    await _auth
                                        .signInWithCredential(credential);
                                final User? user = userCredential.user;
                                gmail = user!.email.toString();
                                profilephoto = user.photoURL.toString();
                                name = user.displayName.toString();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    RouteName.mainScreen, (route) => false);
                              } catch (_) {
                              } finally {
                                if (_auth.currentUser == null) {
                                } else {
                                  final User? user = _auth.currentUser;
                                  gmail = user!.email.toString();
                                  profilephoto = user.photoURL.toString();
                                  name = user.displayName.toString();
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      RouteName.mainScreen, (route) => false);
                                }
                              }
                            },
                            icon: loadingForGoogleLoginOnAuth
                                ? Container()
                                : const FaIcon(
                                    FontAwesomeIcons.google,
                                    color: Colors.blueAccent,
                                  ),
                            label: loadingForGoogleLoginOnAuth
                                ? const CircularProgressIndicator(
                                    color: Colors.green,
                                  )
                                : Text(AppLocalizations.of(context)!
                                    .continueWithGoogle),
                          ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.blue[900]),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                backgroundColor: Colors.blue[900]),
                            onPressed: () async {
                              setState(() {
                                loadingForFacebookLoginOnAuth = true;
                              });

                              await provider.signInWithFacebook().then((value) {
                                setState(() {
                                  loadingForFacebookLoginOnAuth = false;
                                });
                              });
                              if (provider.isLoggedIn) {
                                // ignore: use_build_context_synchronously
                                Navigator.of(context)
                                    .pushReplacementNamed(RouteName.mainScreen);
                              }
                            },
                            icon: loadingForFacebookLoginOnAuth
                                ? Container()
                                : const FaIcon(
                                    FontAwesomeIcons.facebook,
                                    color: Colors.white,
                                  ),
                            label: loadingForFacebookLoginOnAuth
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    AppLocalizations.of(context)!
                                        .continueWithFacebook,
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),

                        TextButton(onPressed: (){
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const Home();
                                  }));


                        }, child:Text('Home'))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
