// ignore_for_file: prefer_const_constructors

import 'package:cab_driver/brand_colors.dart';
import 'package:cab_driver/screens/mainpage.dart';
import 'package:cab_driver/screens/registration.dart';
import 'package:cab_driver/widgets/ProgressDialog.dart';
import 'package:cab_driver/widgets/TaxiButton.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  static String id = 'Login_Page';
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void login() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              status: 'Logging you in... ',
            ));
    try {
      final user = (await _auth
              .signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
              .catchError((ex) {
        Navigator.pop(context);
        FirebaseAuthException thisex = ex;
        showSnackbar(thisex.message!);
      }))
          .user;

      if (user != null) {
        DatabaseReference userRef =
            FirebaseDatabase.instance.reference().child('drivers/${user.uid}');

        userRef.once().then((data) => {
              if (data.snapshot.value != null)
                {
                  Navigator.pushNamedAndRemoveUntil(
                      context, MainPage.id, (route) => false)
                }
              else
                {showSnackbar('snapshot value is null')}
            });
      }
      showSnackbar('${user!.email} signed in');
    } catch (e) {
      showSnackbar(e.toString());
      print(e.toString());
    }
  }

  void showSnackbar(String title) {
    final snackBar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 70,
                ),
                Image(
                  image: AssetImage('assets/images/logo.png'),
                  alignment: Alignment.center,
                  height: 100.0,
                  width: 100.0,
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Sign In as a Driver',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email address',
                          labelStyle: TextStyle(fontSize: 14),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(fontSize: 14),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TaxiButton(
                        color: BrandColors.colorAccentPurple,
                        title: 'LOGIN',
                        onPressed: () async {
                          // var connectivityResult =
                          //     Connectivity().checkConnectivity();
                          // if (connectivityResult != ConnectivityResult.mobile &&
                          //     connectivityResult != ConnectivityResult.wifi) {
                          //   showSnackbar('No internet connectivity');
                          //   return;
                          // }
                          if (!emailController.text.contains('@')) {
                            showSnackbar('Please enter a valid email');
                            return;
                          }
                          if (passwordController.text.length < 6) {
                            showSnackbar('Please enter a valid password');
                            return;
                          }
                          login();
                        },
                      ),
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RegisterationPage.id);
                    },
                    child: Text(
                      'Dont\'t have an account, sign up here',
                      style: TextStyle(color: Colors.black),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
