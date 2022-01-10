import 'package:attic/screens/auth/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _auth = FirebaseAuth.instance;
  final currentUser = FirebaseFirestore.instance
      .collection('posts').doc(FirebaseAuth.instance.currentUser!.uid).snapshots();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.75,
      child: Column(
        children: [
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                buildUsername(context),
                IconButton(
                    onPressed: (){
                      _auth.signOut();
                      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (route) => false);
                    },
                    icon:const Icon(
                      IconData(0xe3b3, fontFamily: 'MaterialIcons'),
                      color: Colors.green,
                      size: 35,
                    )
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget buildUsername(context){
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).snapshots(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            var userDocument = snapshot.data.data();
            return Text(
              userDocument['username'],
              style: GoogleFonts.acme(
                  textStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.withOpacity(0.7),
                  )
              ),
            );
          }
          return Container();
        }
    );
  }
}
