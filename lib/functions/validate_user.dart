import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

Future<dynamic> validateUser(
    String email, String password, FirebaseAuth _auth, BuildContext context, Future function) async {
  try {
    await function;
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
              content: new Text("Your password must be at least 6 characters long"),
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

      return false;
    }
  }
}