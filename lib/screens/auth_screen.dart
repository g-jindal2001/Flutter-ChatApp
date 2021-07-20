import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {//Since we are using setState therefore it is a statefull widget
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String username,
    String password,
    File image,
    bool isLogin,
    BuildContext ctx
  ) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      //handling errors
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final ref = FirebaseStorage.instance.ref().child('user_image').child(authResult.user.uid + '.jpg');//.ref gives us access to the main cloud storage area(also called a bucket) and .child is used to create folders and sub folders within it 

        await ref.putFile(image);//.putFile actually uploads the file in the folders which we specified in variable ref

        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance// Here we send all the user - related data to Firebase's database 
            .collection('users')
            .doc(authResult.user.uid)
            .set({
          //This part is in else block because we want to store the username after we sign up the user.We want to perform thid action only when we are signing up the user NOT logging in
          'username': username,
          'email': email,
          'image_url': url,
        });
      }
    } on FirebaseAuthException catch (err) {
      var message = 'An error occured, please try again later';

      if (err.message != null) {
        message = err.message;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}
