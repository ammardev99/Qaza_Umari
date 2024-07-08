import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qaza_e_umri/constants/route_name.dart';
import 'package:qaza_e_umri/ui/screens/homepage/menu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthProviderAuth extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  bool get isLoggedIn => _auth.currentUser != null;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Google sign in
  Future<void> googleSignIn(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          return null; // The user canceled the sign-in
        }
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;
        gmail = user!.email.toString();
        profilephoto = user.photoURL.toString();
        name = user.displayName.toString();
      Navigator.of(context)
          .pushNamedAndRemoveUntil(RouteName.mainScreen, (route) => false);

    } catch (_) {
    } finally {
      if (_auth.currentUser == null) {
      } else {
        final User? user = _auth.currentUser;
        gmail = user!.email.toString();
        profilephoto = user.photoURL.toString();
        name = user.displayName.toString();
        // ignore: use_build_context_synchronously
        Navigator.of(context)
            .pushNamedAndRemoveUntil(RouteName.mainScreen, (route) => false);
      }

      _isLoading = false;
      notifyListeners();
    }
  }

  /// fb authentication
  Future<void> signInWithFacebook() async {
    final fb = FacebookLogin();
    try {
      final res = await fb.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ]);
      switch (res.status) {
        case FacebookLoginStatus.success:
          final FacebookAccessToken? accessToken = res.accessToken;
          final AuthCredential authCredential =
              FacebookAuthProvider.credential(accessToken!.token);
          await _auth.signInWithCredential(authCredential);
          notifyListeners();
          break;
        case FacebookLoginStatus.cancel:
          break;
        case FacebookLoginStatus.error:
          break;
      }
    } catch (_) {}
  }

  Future<void> signOut(BuildContext context) async {
    try {
      // Check if user is signed in with google sign in
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
      }

      await _auth.signOut().then((_) {
        notifyListeners();
      });
    } catch (e) {
      //print(e.toString());
    }
  }


  // create user
    static Future createAccountwithEmail(String email, String password,BuildContext context)async{
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password,);
      return AppLocalizations.of(context)!.accountCreated;
    }on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
    
    return (AppLocalizations.of(context)!.thePasswordProvidedIsTooWeak);
  } else if (e.code == 'email-already-in-use') {
    return (AppLocalizations.of(context)!.theAccountAlreadyExistsForThatEmail);
  }
    } catch(e){
      e.toString();
    }
  }

// Email Auth
static Future emailAuth(String email, String password)async{
 try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
       return "Login Successful";
    }on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
    return ('The password provided is Wrong.');
  }
    } catch(e){
      return e.toString();
    }
}
}
