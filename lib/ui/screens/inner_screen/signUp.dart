import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:provider/provider.dart';
import 'package:qaza_e_umri/ui/screens/homepage/welcome_screen.dart';
import 'package:qaza_e_umri/ui/screens/login_screen.dart';
import 'package:qaza_e_umri/ui/widgets/reusble_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/provider/auth_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}
 bool isLoading =false;
  String? username;
  String? email;
  String? phone;
  String? password;
   GlobalKey<FormState> key = GlobalKey<FormState>();
class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
        final provider = Provider.of<AuthProviderAuth>(context);
    return  Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: key,
          child: Column(children: [
             Center(
                  child: Container(
                    padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
                    child: Image.asset(
                      'assets/images/icon.png',
                      height: 150,
                      width: 150,
                      scale: 2,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Column(
                  children: <Widget>[
                     Center(
                        child: Text(
                      AppLocalizations.of(context)!.signIn,
                      style: TextStyle(color: Colors.black, fontSize: 35),
                    )),
                    const SizedBox(
                      height: 30,
                    ),
                       Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child: TextFormField(
                        validator:ValidationBuilder().maxLength(10).minLength(3).build(),
                        onChanged: (value) {
                          username=value;
                        },
                        decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                        
                       ),
                       
                        labelText: AppLocalizations.of(context)!.enterName,
                        prefixIcon: Icon(Icons.person,color: Colors.green,)
                        
                        
                      ),
                      ),
                    ),
                       const SizedBox(
                      height: 15,
                    ),
                       Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child: TextFormField(
                       validator:ValidationBuilder().email().maxLength(50).build(),
                        onChanged: (value) {
                          email=value;
                        },
                        decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                       ),
                        labelText: AppLocalizations.of(context)!.enterEmail,
                        prefixIcon: Icon(Icons.email,color: Colors.green,)
                        
                      ),
                      ),
                    ),
                       const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child: TextFormField(
                     validator:ValidationBuilder().phone().build(),
          
                        onChanged: (value) {
                          phone=value;
                        },
                        decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                       ),
                        labelText: AppLocalizations.of(context)!.enterPhone,
                        prefixIcon: Icon(Icons.phone,color: Colors.green,)
                        
                      ),
                      ),
                    ),
                     const SizedBox(
                      height: 15,
                    ),
                    Padding(
                 padding: const EdgeInsets.only(left: 10,right: 10),
                      child: TextFormField(
                       validator:ValidationBuilder().maxLength(12).minLength(6).build(),
          
                         onChanged: (value) {
                          password=value;
                        },
                        decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        labelText: AppLocalizations.of(context)!.enterPassword,
                        prefixIcon: Icon(Icons.lock,color: Colors.green,)
                      ),),
                    ),
                     const SizedBox(
                      height: 30,
                    ),
                 Rounded_Button(
                  loading: isLoading,
                  ontap: (){
              if(key.currentState?.validate()??false){
                  try {
                     setState(() {
                     isLoading = true;
                   });
                   AuthProviderAuth.createAccountwithEmail(email!, password!,context).then((value) {
                              Navigator.push(context, MaterialPageRoute(builder:  (context) {
                                                return const WelcomeScreen();
                                              }));
                          });
                      setState(() {
                     isLoading = false;
                   });
                 } catch (e) {
                   print(e.toString());
                 }
             }
                   
                 }
                 ,title: AppLocalizations.of(context)!.signUp,),
                Padding(
                 padding: const EdgeInsets.only(right: 15,top: 10),
                 child:   Align(
                    alignment: Alignment.centerRight,
                    child:  InkWell(
                      onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder:  (context) {
                            return const LoginScreen();
                          }));
                      },
                      child: Text(AppLocalizations.of(context)!.alreayHaveAccount,style: TextStyle(color: Colors.green, fontSize: 18),))),
               ),
                     const SizedBox(
                      height: 30,
                    ),
          ],
          ),
                 ] ),
        )
        )
        );
      
    
  }
}