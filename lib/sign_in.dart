import 'package:firbeas/auth_servic.dart';
import 'package:firbeas/prefs_servic.dart';
import 'package:firbeas/utils_servic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var _isLoading = false;
  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  _doSignIn() {
    String email = emailcontroller.text.toString().trim();
    String password = passwordcontroller.text.toString().trim();
    if (email.isEmpty || password.isEmpty) return;
    Authservic.signInUser(context, email, password)
        .then((user) => {_getFirebaseUser(user!)});

    setState(() {
      _isLoading = true;
    });

    Navigator.pushReplacementNamed(context, 'home');
  }

  _getFirebaseUser(User? user) async {
    setState(() {
      _isLoading = false;
    });

    if (user != null) {
      await Prefs.saveUserId(user.uid);
      Navigator.of(context).pushReplacementNamed('home');
    } else {
      Utils.fireToast("Chekc your email or password");
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
                      _doSignIn();
                    },
                    color: Colors.blue,
                    child: Text(
                      'Sign In',
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
                    Text('Do\'nt have account?'),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      child: Text('Sign Up'),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('sign_up');
                      },
                    )
                  ],
                )
              ],
            ),
          ),
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox.shrink()
        ]),
      ),
    );
  }
}
