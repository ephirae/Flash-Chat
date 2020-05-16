import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

final _firestore = Firestore.instance;

Future<dynamic> validateUser(String email, String password, FirebaseAuth _auth,
    BuildContext context, Future function) async {
  try {
    await function;

    final user = await _auth.currentUser();

    final userAlreadyExists = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .getDocuments();

    if (userAlreadyExists.documents.length == 0) {
    _firestore.collection('users').document(user.uid).setData({
        'email': email,
        'typing': false,
      });
    }
    return true;
  } catch (e) {
    print('Error caught! $e');
    if (e is PlatformException) {
      if (e.code == 'ERROR_WEAK_PASSWORD') {
        print('weak password');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content:
                  new Text("Your password must be at least 6 characters long"),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("TRY AGAIN"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      if (e.code == 'ERROR_INVALID_EMAIL') {
        print('invalid email');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: new Text(
                  "Your email is incorrect. Please check the spelling and try again"),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("TRY AGAIN"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        print('email in use');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: new Text(
                  "That email is already in use. Please log in or use a different email."),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("TRY AGAIN"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      if (e.code == 'ERROR_USER_NOT_FOUND') {
        print('user not found');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: new Text(
                  "That user cannot be found. Please register or try again."),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("TRY AGAIN"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }

      return false;
    }
  }
}
