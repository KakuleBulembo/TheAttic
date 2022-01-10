import 'package:attic/components/input_password_field.dart';
import 'package:attic/components/rounded_button.dart';
import 'package:attic/components/rounded_input_field.dart';
import 'package:attic/components/snack_content.dart';
import 'package:attic/screens/auth/registration_screen.dart';
import 'package:attic/screens/user/user_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../constants.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  late String email;
  late String password;
  bool vuePass = true;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: showSpinner,
      opacity: 0.5,
      color: kPrimaryColor,
      progressIndicator: const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.green),
      ),
      child: Scaffold(
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'THE ATTIC',
                  style: GoogleFonts.pacifico(
                      textStyle: Theme.of(context).textTheme.headline2!.copyWith(
                        color: Colors.green,
                      ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                RoundedInputField(
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please enter the email';
                    }
                    return null;
                  },
                    hintText: 'Enter Email',
                    icon: Icons.email,
                    onChanged: (value){
                       email = value;
                    }
                ),
                InputPasswordField(hintText: 'Enter Password',
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please enter the email';
                      }
                      return null;
                    },
                    onTap: (){
                      setState(() {
                        if(vuePass == true) {
                          vuePass = false;
                        }
                        else{
                          vuePass = true;
                        }
                      });
                    },
                    onChanged: (value){
                       password = value;
                    }
                ),
                const SizedBox(
                  height: 10,
                ),
                RoundedButton(
                    buttonName: 'Login',
                    color: Colors.green,
                    onPressed: () async{
                      if(_formKey.currentState!.validate()){
                        try{
                          setState(() {
                            showSpinner = true;
                          });
                          await _auth.signInWithEmailAndPassword(
                              email: email,
                              password: password,
                          ).then((value) {
                            setState(() {
                              showSpinner = false;
                            });
                            Navigator.pushNamed(context, UserInterface.id);
                          });
                        }
                        catch(e){
                          setState(() {
                            showSpinner = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: SnackContent(
                                  label: 'Wrong credentials',
                                ),
                                backgroundColor: Colors.red,
                              )
                          );
                        }
                      }
                    }
                    ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    const Text(
                      'You do not have an account ?',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    TextButton(
                      onPressed: (){
                        Navigator.pushNamed(context, RegistrationScreen.id);
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
