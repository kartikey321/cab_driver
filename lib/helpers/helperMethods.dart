import 'dart:math';

import 'package:cab_driver/DataProvider.dart';
import 'package:cab_driver/datamodels/History.dart';
import 'package:cab_driver/datamodels/directionDetails.dart';
import 'package:cab_driver/globalvariables.dart';
import 'package:cab_driver/helpers/requestHelper.dart';
import 'package:cab_driver/widgets/ProgressDialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

  static void getHistoryInfo(context) {
    DatabaseReference earningRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentFirebaseUser!.uid}/earnings');
    earningRef.once().then((data) {
      if (data.snapshot.value != null) {
        String earnings = data.snapshot.value.toString();
        Provider.of<AppData>(context, listen: false).updateEarnings(earnings);
      }
    });

    DatabaseReference historyRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentFirebaseUser!.uid}/history');
    historyRef.once().then((data) {
      var snapshot = data.snapshot;
      if (snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.value as Map<String, dynamic>;
        print(values);
        int tripCount = values.length;

        //update trip count to data provider
        Provider.of<AppData>(context, listen: false)
            .updateTripCount(tripCount.toString());

        List<String> tripHistoryKeys = [];
        values.forEach((key, value) {
          tripHistoryKeys.add(key);
        });

        //update trip keys to data provider
        Provider.of<AppData>(context, listen: false)
            .updateTripKeys(tripHistoryKeys);

        getHistoryData(context);
      }
    });
  }

  static void getHistoryData(context) {
    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;
    for (String key in keys) {
      DatabaseReference historyRef =
          FirebaseDatabase.instance.reference().child('rideRequest/$key');
      historyRef.once().then((data) {
        if (data.snapshot.value != null) {
          var history = History.fromSnapshot(data.snapshot);
          Provider.of<AppData>(context, listen: false)
              .updateTrpHistory(history);
          print(history.destination);
        }
      });
    }
  }

  static String formatMyDate(String dateString) {
    DateTime thisdate = DateTime.parse(dateString);
    String formattedDate =
        '${DateFormat.MMMd().format(thisdate)}, ${DateFormat.y().format(thisdate)} - ${DateFormat.jm().format(thisdate)}';
    return formattedDate;
  }
}
