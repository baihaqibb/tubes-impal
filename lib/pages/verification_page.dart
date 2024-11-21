import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_cal/pages/home_page.dart';
import 'package:simple_cal/pages/login_page.dart';
import 'package:simple_cal/themes.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();
    }

    timer =
        Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerification());
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: danger,
    ));
  }

  Future checkEmailVerification() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  void cancelRegister(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: danger),
      ),
      onPressed: () async {
        print("delete");
        Navigator.pop(context);

        showDialog(
            context: context,
            builder: (context) {
              return Center(
                child: CircularProgressIndicator(),
              );
            });

        try {
          await FirebaseAuth.instance.currentUser!.delete();
        } on FirebaseAuthException catch (e) {
          showErrorSnackBar("Something went wrong :( \nError Code: ${e.code}");
        }

        if (context.mounted) {
          Navigator.pop(context);
        }
      },
    );
    Widget backButton = TextButton(
      child: Text("Back"),
      onPressed: () {
        Navigator.pop(context);
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Cancel Registration"),
      content: Text(
          "Do you want to cancel the registration process? \n(This process cannot be undone!)"),
      actions: [
        backButton,
        cancelButton,
      ],
    ); // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future sendVerificationEmail() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      showErrorSnackBar("Something went wrong :( \nError Code: ${e.code}");
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? HomePage()
      : Scaffold(
          appBar: AppBar(
            title: Text("Verify Email"),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  cancelRegister(context);
                },
                icon: Icon(Icons.arrow_back_sharp)),
          ),
          body: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "A verification email has been sent, please check your email inbox",
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  onPressed: () => {},
                  label: Text("Resend email"),
                  icon: Icon(Icons.email),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                )
              ],
            ),
          ),
        );
}
