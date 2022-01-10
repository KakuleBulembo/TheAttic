import 'package:attic/components/input_password_field.dart';
import 'package:attic/components/rounded_button.dart';
import 'package:attic/components/rounded_input_field.dart';
import 'package:attic/components/snack_content.dart';
import 'package:attic/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);
  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late String username;
  late String email;
  late String password;
  late String confirmPassword;
  final _auth = FirebaseAuth.instance;
  bool isAdmin = false;
  bool showSpinner = false;
  bool vuePass = true;
  final _formKey = GlobalKey<FormState>();

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
                RoundedInputField(hintText: 'Enter Username',
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please enter the username';
                      }
                      return null;
                    },
                    icon: Icons.person,
                    onChanged: (value){
                      username = value;
                    }
                ),
                RoundedInputField(
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please enter the email';
                      }
                      else{
                        if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                          return null;
                        }
                        else{
                          return 'Enter a valid email';
                        }
                      }
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
                        return 'Please enter the username';
                      }
                      else{
                        if(value.length < 6){
                          return 'Minimum 6 characters';
                        }
                        return null;
                      }
                    },
                    obscureText: vuePass,
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
                InputPasswordField(hintText: 'Confirm Password',
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please enter the username';
                      }
                      else{
                        if(value != password){
                          return 'Password does not match';
                        }
                        return null;
                      }
                    },
                    obscureText: vuePass,
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
                       confirmPassword = value;
                    }
                    ),
                RoundedButton(buttonName: 'Register',
                    color: Colors.lightGreen,
                    onPressed: () async{
                      if(_formKey.currentState!.validate()){
                        setState(() {
                          showSpinner = true;
                        });
                        await _auth.createUserWithEmailAndPassword(
                            email: email,
                            password: password
                        ).then((value) {
                          User? currentUser = _auth.currentUser;
                          FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).set({
                            'uid' : currentUser.uid,
                            'username': username,
                            'email' : email,
                            'ts' : DateTime.now(),
                          });
                        }).then((value) {
                          setState(() {
                            showSpinner = false;
                          });
                          Navigator.pushNamed(context, LoginScreen.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(
                                content: SnackContent(
                                  label: 'Account Created Successfully',
                                ),
                              backgroundColor: Colors.green,
                            )
                          );
                        });
                      }
                    }
                    ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    const Text(
                      'Already Have an Account ?',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    TextButton(
                      onPressed: (){
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                      child: const Text(
                        'Sign In',
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
        )
      ),
    );
  }
}
