import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Stream<QuerySnapshot> posts = FirebaseFirestore
      .instance.collection('posts')
      .orderBy('totalLikes', descending: true)
      .snapshots();
  String ? authorID;
  dynamic time;
  final _auth = FirebaseAuth.instance;
  int totalLikes = 0;
  bool liked = false;
  String ? ref;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: posts,
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            final data = snapshot.requireData;
            return SizedBox(
              height: size.height * 0.75,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: data.size,
                  itemBuilder: (context, index){
                    authorID = data.docs[index]['uid'];
                    time = data.docs[index]['ts'];
                    totalLikes = data.docs[index]['totalLikes'];
                    ref = data.docs[index].reference.id;
                    return Column(
                      children: [
                        buildUsername(context),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: size.width * 0.4,
                              width: size.width * 0.85,
                              decoration:const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Image.network(
                                data.docs[index]['imgUrl'],
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              data.docs[index]['title'],
                              style: GoogleFonts.acme(
                                  textStyle:const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  )
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            Flexible(
                              child: Text(
                                data.docs[index]['description'],
                                style: GoogleFonts.acme(
                                    textStyle:const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      height: 1.5,
                                    )
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                                onPressed: () async{
                                  Future<DocumentSnapshot<Map<String, dynamic>>> subSnapshot = FirebaseFirestore.instance
                                      .collection('posts')
                                      .doc(data.docs[index].reference.id)
                                      .collection('likedBy')
                                      .doc(_auth.currentUser!.uid).get();
                                  DocumentSnapshot doc = await subSnapshot;
                                  if(doc.exists){
                                    DocumentReference documentReference = FirebaseFirestore.instance
                                        .collection('posts')
                                        .doc(data.docs[index].reference.id)
                                        .collection('likedBy')
                                        .doc(_auth.currentUser!.uid);
                                    int likes = totalLikes - 1;
                                    FirebaseFirestore.instance.runTransaction((Transaction transaction) async{
                                      transaction.delete(documentReference);
                                    }).then((value) {
                                      FirebaseFirestore.instance
                                          .collection('posts')
                                          .doc(data.docs[index].reference.id)
                                          .update({
                                        'totalLikes' : likes,
                                      });
                                    }).then((value) {
                                      setState(() {
                                        liked = false;
                                      });
                                    });
                                  }
                                  else{
                                    int likes = totalLikes + 1;
                                    FirebaseFirestore.instance.collection('posts')
                                        .doc(data.docs[index].reference.id)
                                        .collection('likedBy')
                                        .doc(_auth.currentUser!.uid)
                                        .set({
                                      'userId' : _auth.currentUser!.uid
                                    }).then((value){
                                      FirebaseFirestore.instance
                                          .collection('posts')
                                          .doc(data.docs[index].reference.id)
                                          .update({
                                        'totalLikes' : likes,
                                      });
                                    }).then((value) {
                                      setState(() {
                                        liked = true;
                                      });
                                    });
                                  }
                                },
                                icon: Icon(
                                    Icons.favorite,
                                  size: 30,
                                  color: liked == true ? const Color(0xFF800517) : Colors.grey,
                                ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${data.docs[index]['totalLikes']}  Likes',
                              style: GoogleFonts.aladin(
                                textStyle: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: liked == true ? const Color(0xFF800517) : Colors.grey,
                                )
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            IconButton(
                                onPressed: (){},
                                icon:const Icon(
                                    Icons.comment,
                                  size: 30,
                                  color: Color(0xFFFfffe6),
                                )
                            )
                          ],
                        ),
                        Container(
                          height: 10,
                          width: double.infinity,
                          color: kPrimaryColor,
                          child:const Text(''),
                        ),
                      ],
                    );
                  }
              ),
            );
          }
          return Container();
        }
    );
  }
  Widget buildUsername(context){
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(authorID).snapshots(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            var userDocument = snapshot.data.data();
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        userDocument['username'],
                        style: GoogleFonts.acme(
                            textStyle:const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        DateFormat('hh:mm  dd/MM/yyyy')
                            .format(DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch)),
                        style: GoogleFonts.acme(
                          textStyle:const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return Container();
        }
    );
  }
}
