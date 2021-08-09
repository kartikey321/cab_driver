import 'dart:math';

import 'package:cab_driver/datamodels/directionDetails.dart';
import 'package:cab_driver/globalvariables.dart';
import 'package:cab_driver/helpers/requestHelper.dart';
import 'package:cab_driver/widgets/ProgressDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HelperMethods {
  static Future<DirectionDetails?> getDirectionDetails(
      LatLng startPosition, LatLng endPosition) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$mapKey';
    var response = await RequestHelper.getRequest(url);
    if (response == 'failed') {
      return null;
    }
    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.distanceText =
        response['routes'][0]['legs'][0]['distance']['text'];
    directionDetails.distanceValue =
        response['routes'][0]['legs'][0]['distance']['value'];

    directionDetails.durationText =
        response['routes'][0]['legs'][0]['duration']['text'];
    directionDetails.durationValue =
        response['routes'][0]['legs'][0]['duration']['value'];

    directionDetails.encodedPoints =
        response['routes'][0]['overview_polyline']['points'];

    return directionDetails;
  }

  static int estimateFares(DirectionDetails details, int durationValue) {
    //base fare = 40₹
    //per km = 15₹
    //per min = 10₹

    double baseFare = 40;
    double distanceFare = (details.distanceValue! / 1000) * 15;
    double durationFare = (durationValue / 60) * 10;

    double totalFare = baseFare + distanceFare + durationFare;

    return totalFare.truncate();
  }

  static double generateRandomNumber(int max) {
    var randomGenerator = Random();
    int randInt = randomGenerator.nextInt(max);

    return randInt.toDouble();
  }

  static void disableHomeTabLocationUpdates() {
    try {
      homeTabPositionStream!.pause();
    } catch (e) {
      print(e);
    }

    Geofire.removeLocation(currentFirebaseUser!.uid);
  }

  static void enaableHomeTabLocationUpdates() {
    homeTabPositionStream!.resume();
    Geofire.setLocation(currentFirebaseUser!.uid, currentPosition!.latitude,
        currentPosition!.longitude);
  }

  static void showProgressDialog(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              status: 'Please wait',
            ));
  }
}
