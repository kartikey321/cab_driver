// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cab_driver/brand_colors.dart';
import 'package:cab_driver/globalVariables.dart';
import 'package:cab_driver/widgets/TaxiButton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'mainpage.dart';

class VehicleInfo extends StatelessWidget {
  static const String id = 'vehicle_info';

  var carModelController = TextEditingController();
  var carColorController = TextEditingController();
  var vehicleNumberController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  void showSnackbar(String title) {
    final snackBar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
    );
    scaffoldKey.currentState!.showSnackBar(snackBar);
  }

  void updateProfile(context) {
    String id = currentFirebaseUser!.uid;

    DatabaseReference driveRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/$id/vehicle_details');

    Map map = {
      'car_color': carColorController.text,
      'car_model': carModelController.text,
      'vehicle_no': vehicleNumberController.text,
    };

    driveRef.set(map);
    Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/images/logo.png',
                height: 110,
                width: 110,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Enter vehicle details',
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Brand-Bold',
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextField(
                      controller: carModelController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Car Model',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: carColorController,
                      decoration: InputDecoration(
                        labelText: 'Car Color',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: vehicleNumberController,
                      decoration: InputDecoration(
                        labelText: 'Vehicle number',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TaxiButton(
                      title: 'PROCEED',
                      color: BrandColors.colorGreen,
                      onPressed: () {
                        if (carModelController.text.length < 3) {
                          showSnackbar('Please provide a valid car model');
                          return;
                        }
                        if (carModelController.text.length < 3) {
                          showSnackbar('Please provide a valid car color');
                          return;
                        }
                        if (vehicleNumberController.text.length < 3) {
                          showSnackbar('Please provide a valid vehicle number');
                          return;
                        }
                        updateProfile(context);
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
