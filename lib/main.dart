// ignore_for_file: prefer_const_constructors

import 'package:cab_driver/globalVariables.dart';
import 'package:cab_driver/screens/login.dart';
import 'package:cab_driver/screens/mainpage.dart';
import 'package:cab_driver/screens/registration.dart';
import 'package:cab_driver/screens/vehicleinfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp();
  currentFirebaseUser = FirebaseAuth.instance.currentUser;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Brand-Regular',
        primarySwatch: Colors.blue,
      ),
      initialRoute: (currentFirebaseUser == null) ? LoginPage.id : MainPage.id,
      routes: {
        MainPage.id: (context) => const MainPage(),
        RegisterationPage.id: (context) => RegisterationPage(),
        VehicleInfo.id: (context) => VehicleInfo(),
        LoginPage.id: (context) => LoginPage(),
      },
    );
  }
}
