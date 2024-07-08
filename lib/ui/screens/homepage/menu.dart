import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qaza_e_umri/core/provider/auth_provider.dart';
import 'package:qaza_e_umri/constants/route_name.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String gmail = '';
String name = '';
String profilephoto = '';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  void initState() {
    super.initState();
    getDetails();
  }

  getDetails() async {
    User currentUser = FirebaseAuth.instance.currentUser!;
    setState(() {
      gmail = currentUser.providerData[0].email!;
    //  profilephoto = currentUser.photoURL!;
     // name = currentUser.displayName!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProviderAuth>(context);
    return SafeArea(
      child: Drawer(
        width: 310,
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        child: ListView(
          // Remove padding
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(name,
                  style: const TextStyle(color: Colors.white, fontSize: 20)),
              accountEmail:
                  Text(gmail, style: const TextStyle(color: Colors.white)),
              currentAccountPicture: ClipRRect(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(100),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: FancyShimmerImage(
                    imageUrl: profilephoto,
                    boxFit: BoxFit.cover,
                    errorWidget: Image.asset(
                      'assets/images/profile.png',
                    ),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: const NetworkImage(
                      'https://media.istockphoto.com/id/1487246460/photo/moon-with-mosque-dome-mubarak-muharram-and-sky-night-background-islamic-greeting-ramadan.webp?b=1&s=170667a&w=0&k=20&c=3JSIaL2nzIYgYDLnqAelgBLVpPMLJCZ-TYcFaNHVOWc=',
                    ),
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.6), BlendMode.dstATop)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.play_lesson_sharp),
              title:  Text(AppLocalizations.of(context)!.howItWorks),
              onTap: (() async {
                var url =
                    'https://sites.google.com/view/qaza-e-umri-howitworks/home';
                // ignore: deprecated_member_use
                if (await canLaunch(url)) {
                  // ignore: deprecated_member_use
                  await launch(url);
                } else {
                  throw AppLocalizations.of(context)!.cannotLoadUrl;
                }
              }),
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: Text(AppLocalizations.of(context)!.shareApp),
              onTap: (() {
                Share.share(
                    '${AppLocalizations.of(context)!.checkOutTheLink} https://play.google.com/store/apps/details?id=com.twintechsoft.islamicapp.qaza_e_umri',
                    subject: AppLocalizations.of(context)!.qazaUmri);
              }),
            ),
            // ListTile(
            //   leading: Icon(Icons.account_circle_outlined),
            //   title: Text('My Profile'),
            //   onTap: (() {
            //     //Get.to(ProfileScreen());
            //   }),
            // ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.policy_sharp),
              title: Text(AppLocalizations.of(context)!.privacyPolicies),
              onTap: (() async {
                var url =
                    'https://docs.google.com/document/d/1LR2Bup8c49IolOIIaBN3oqxn0cpFXb1hpebPEIzGlj8/edit?usp=sharing';
                // ignore: deprecated_member_use
                if (await canLaunch(url)) {
                  // ignore: deprecated_member_use
                  await launch(url);
                } else {
                  throw AppLocalizations.of(context)!.cannotLoadUrl;
                }
              }),
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title:  Text(AppLocalizations.of(context)!.termsOfUse),
              onTap: (() async {
                var url =
                  'https://docs.google.com/document/d/1l4wTslUC0KSyXjL9seLOqIqG9aCauROAek186qTVLS8/edit?usp=sharing';
                // ignore: deprecated_member_use
                if (await canLaunch(url)) {
                  // ignore: deprecated_member_use
                  await launch(url);
                } else {
                  throw AppLocalizations.of(context)!.cannotLoadUrl;
                }
              }),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: Text(AppLocalizations.of(context)!.signOut),
              onTap: (() async {
                await provider.signOut(context);
                if (!provider.isLoggedIn) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      RouteName.loginScreen, (route) => false);
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
