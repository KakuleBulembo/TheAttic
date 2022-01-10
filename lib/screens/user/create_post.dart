import 'package:attic/components/firebase_api.dart';
import 'package:attic/components/input_form_field.dart';
import 'package:attic/components/snack_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../../constants.dart';
import 'dart:io';
import 'package:path/path.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);
  static String id = 'create_post';

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  File ? imageFile;
  ImagePicker ? imagePicker;
  final _formKey = GlobalKey<FormState>();
  String ? title;
  String ? description;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  TaskSnapshot ? snap;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoadingOverlay(
      isLoading: showSpinner,
      opacity: 0.5,
      color: kPrimaryColor,
      progressIndicator: const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.green),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Add Post',
            style: GoogleFonts.pacifico(
              textStyle:const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.green
              ),
            ),
          ),
          leading:const BackButton(
            color: Colors.green,
          ),
          actions: [
            TextButton(
                onPressed: () async{
                  if(_formKey.currentState!.validate()){
                    if(imageFile != null){
                      setState(() {
                        showSpinner = true;
                      });
                      final destination = 'posts/${basename(imageFile!.path)}';
                      snap = await FirebaseApi.uploadFile(destination, imageFile!);
                      if(snap!.state == TaskState.success){
                        final String getUrl = await snap!.ref.getDownloadURL();
                          User ? user = _auth.currentUser;
                          FirebaseFirestore.instance.collection('posts').doc().set({
                            'uid' : user!.uid,
                            'title' : title,
                            'description' : description,
                            'imgUrl' : getUrl,
                            'totalLikes' : 0,
                            'ts' : DateTime.now(),
                          }).then((value) {
                            setState(() {
                              showSpinner = false;
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: SnackContent(
                                  label: 'Post Added Successfully',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          });
                      }
                    }
                    else {
                      return;
                    }
                  }
                },
                child: Text(
                  'Post',
                  style: GoogleFonts.acme(
                    textStyle: TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.green.withOpacity(0.7),
                    ),
                  ),
                ),
            ),
          ],
          backgroundColor: kPrimaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    imageFile == null ? SizedBox(
                      height: size.width * 0.6,
                      width: size.width * 0.8,
                      child: GestureDetector(
                        onTap: () async{
                          var source = ImageSource.gallery;
                          XFile? image = await imagePicker!.pickImage(
                              source: source,
                          );
                          setState(() {
                            imageFile = File(image!.path);
                          });
                        },
                        child: Image.asset(
                            'images/addImage.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ) : SizedBox(
                      height: size.width * 0.6,
                      width: size.width * 0.8,
                      child: GestureDetector(
                        onTap: ()async{
                          var source = ImageSource.gallery;
                          XFile? image = await imagePicker!.pickImage(
                            source: source,
                          );
                          setState(() {
                            imageFile = File(image!.path);
                          });
                        },
                        child: Image.file(
                            imageFile!,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height *0.03,
                ),
                InputFormField(label: 'Post Title',
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please enter the post title';
                      }
                      return null;
                    },
                    hintText: 'Enter Post Title',
                    maxLines: 1,
                    minLines: 1,
                    onChanged: (value){
                      title = value;
                    },
                    shape: kRoundedBorder,
                ),
                SizedBox(
                  height: size.height *0.03,
                ),
                InputFormField(label: 'Post Description',
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please enter the post description';
                    }
                    return null;
                  },
                  hintText: 'Enter Post Description',
                  maxLines: 3,
                  minLines: 1,
                  onChanged: (value){
                    description = value;
                  },
                  shape: kBottomRounded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

