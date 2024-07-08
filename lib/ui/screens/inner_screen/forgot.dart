import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qaza_e_umri/ui/screens/login_screen.dart';
import '../../widgets/reusble_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController forgotPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.forgotPassword),
        centerTitle: true,
        backgroundColor: Colors.green,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_sharp,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.06),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: h * 0.06),
                Image.asset(
                  'assets/images/icon.png',
                  height: 160,
                  width: 160,
                ),
                const SizedBox(height: 50),
                TextFormField(
                  controller: forgotPasswordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: AppLocalizations.of(context)!.enterEmail,
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.green,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 60,
                ),
                Rounded_Button(
                  loading: loading,
                  title: AppLocalizations.of(context)!.submit,
                  ontap: () async {
                    if (_formKey.currentState!.validate()) {
                      var forgotPasswordEmail = forgotPasswordController.text.trim();
                      setState(() {
                        loading = true;
                      });
                      try {
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: forgotPasswordEmail);

                        setState(() {
                          loading = false;
                        });

                        Get.snackbar(
                          'Email Sent Successfully',
                          'Please check your email to reset your password',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );

                        await Future.delayed(Duration(seconds: 2)); // Wait for snackbar to be visible

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      } on FirebaseAuthException catch (e) {
                        setState(() {
                          loading = false;
                        });
                        Get.snackbar(
                          'Error',
                          e.message.toString(), // Make sure to use e.message instead of e.toString() for better readability
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.red, // Red for error
                          colorText: Colors.white,
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
