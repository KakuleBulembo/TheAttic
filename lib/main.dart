import 'package:attic/constants.dart';
import 'package:attic/screens/auth/login_screen.dart';
import 'package:attic/screens/auth/registration_screen.dart';
import 'package:attic/screens/user/create_post.dart';
import 'package:attic/screens/user/user_interface.dart';
import 'package:attic/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kBackgroundColor,
        canvasColor: kPrimaryColor,
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.white),
        ),
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id : (context) => const WelcomeScreen(),
        LoginScreen.id : (context) => const LoginScreen(),
        RegistrationScreen.id : (context) => const RegistrationScreen(),
        UserInterface.id : (context) => const UserInterface(),
        CreatePost.id : (context) => const CreatePost(),
      },
    );
  }
}
