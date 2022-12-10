import 'dart:io';

import 'package:firbeas/auth_servic.dart';
import 'package:firbeas/prefs_servic.dart';
import 'package:firbeas/utils_servic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/src/foundation/key.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var isLoading = false;
  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  var fullnamecontroller = TextEditingController();
  _dologinUp() {
    String email = emailcontroller.text.toString().trim();
    String password = passwordcontroller.text.toString().trim();
    String name = fullnamecontroller.text.toString().trim();
    setState(() {
      isLoading = true;
    });
    if (name.isEmpty || email.isEmpty || password.isEmpty) return;
    Authservic.signUpUser(context, name, email, password)
        .then((user) => {_getFirebaseUser(user!)});
  }

  _getFirebaseUser(User? user) async {
    setState(() {
      isLoading = false;
    });
    if (user != null) {
      await Prefs.saveUserId(user.uid);
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      Utils.fireToast("Chekc your informations");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: fullnamecontroller,
                  decoration: InputDecoration(hintText: 'Fullname'),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: emailcontroller,
                  decoration: InputDecoration(hintText: 'Email'),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: passwordcontroller,
                  decoration: InputDecoration(hintText: 'Password'),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: MaterialButton(
                    onPressed: () {
                      _dologinUp();
                    },
                    color: Colors.blue,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Have an account?'),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      child: Text('Sign In'),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('sign_in');
                      },
                    )
                  ],
                )
              ],
            ),
          ),
          Center(
              child:
                  isLoading ? CircularProgressIndicator() : SizedBox.shrink())
        ]),
      ),
    );
  }
}
