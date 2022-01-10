import 'package:attic/components/rounded_button.dart';
import 'package:attic/screens/auth/login_screen.dart';
import 'package:attic/screens/auth/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  static String id = 'welcome_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'THE ATTIC',
                style: GoogleFonts.pacifico(
                  textStyle: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Colors.green,
                  )
                ),
              ),
            ],
          ),
          RoundedButton(
              buttonName: 'Login',
              color: Colors.green,
              onPressed: (){
                Navigator.pushNamed(context, LoginScreen.id);
              }
          ),
          RoundedButton(
              buttonName: 'Register',
              color: Colors.lightGreen,
              onPressed: (){
                Navigator.pushNamed(context, RegistrationScreen.id);
              }
          ),
        ],
      ),
    );
  }
}
