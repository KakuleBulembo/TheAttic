import 'package:attic/constants.dart';
import 'package:attic/screens/user/create_post.dart';
import 'package:attic/screens/user/profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home.dart';

class UserInterface extends StatefulWidget {
  const UserInterface({Key? key}) : super(key: key);
  static String id = 'user_interface';

  @override
  _UserInterfaceState createState() => _UserInterfaceState();
}

class _UserInterfaceState extends State<UserInterface> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
              onPressed: (){},
              child: Text(
                'The Attic',
                style: GoogleFonts.pacifico(
                  textStyle:const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.green
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.pushNamed(context, CreatePost.id);
              },
              icon:const Icon(
                  Icons.add,
                color: Colors.green,
                size: 30,
              ),
          ),
        ],
        backgroundColor: kPrimaryColor,
      ),
      body: SizedBox(
        height: size.height * 0.9,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 15,
            right: 15,
            bottom: 20,
          ),
          child: Column(
            children: [
              if(index == 0)
                const Home(),
              if(index == 1)
                const Profile(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: kPrimaryColor,
        index: index,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.green.withOpacity(0.8),
        items: const[
          Icon(Icons.home, size: 30,),
          Icon(Icons.person, size: 30,),
        ],
        onTap: (index) => setState(() {
          this.index = index;
        }),
      ),
    );
  }
}
