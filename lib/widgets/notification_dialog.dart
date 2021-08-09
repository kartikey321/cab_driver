import 'package:cab_driver/brand_colors.dart';
import 'package:cab_driver/datamodels/tripDetails.dart';
import 'package:cab_driver/globalvariables.dart';
import 'package:cab_driver/helpers/helperMethods.dart';
import 'package:cab_driver/screens/newtrippage.dart';
import 'package:cab_driver/widgets/BrandDivider.dart';
import 'package:cab_driver/widgets/ProgressDialog.dart';
import 'package:cab_driver/widgets/TaxiButton.dart';
import 'package:cab_driver/widgets/TaxiOutlineButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationDialog extends StatelessWidget {
  final TripDetails? tripDetails;
  NotificationDialog({this.tripDetails});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(4),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          SizedBox(
            height: 30.0,
          ),
          Image.asset('assets/images/taxi.png'),
          SizedBox(
            height: 16.0,
          ),
          Text(
            'NEW TRIP REQUEST',
            style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 18),
          ),
          SizedBox(
            height: 30.0,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/pickicon.png',
                      height: 18,
                      width: 18,
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          tripDetails!.pickupAddress!,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/desticon.png',
                      height: 18,
                      width: 18,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          tripDetails!.destinationAddress!,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          BrandDivider(),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: TaxiOutlineButton(
                      title: 'DECLINE',
                      color: BrandColors.colorPrimary,
                      onPressed: () async {
                        await assetsAudioPlayer.stop();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Container(
                    child: TaxiButton(
                      title: 'Accept',
                      color: BrandColors.colorGreen,
                      onPressed: () async {
                        await assetsAudioPlayer.stop();
                        checkAvailability(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          )
        ]),
      ),
    );
  }

  void checkAvailability(context) async {
    await assetsAudioPlayer.stop();
    print(tripDetails);
    currentFirebaseUser = FirebaseAuth.instance.currentUser;
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              status: 'Checking availability...',
            ));
    DatabaseReference newRideRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentFirebaseUser!.uid}/newTrip');
    newRideRef.once().then((DataSnapshot snapshot) {
      Navigator.pop(context);
      Navigator.pop(context);
      String thisRideId = "";
      if (snapshot.value != null) {
        thisRideId = tripDetails!.rideId!;
        print("this ride id ${thisRideId}");
        thisRideId = snapshot.value.toString();
      } else {
        print('rider not found');
        Fluttertoast.showToast(
            msg: "rider not found",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (thisRideId == tripDetails!.rideId) {
        print(tripDetails!.rideId);
        print("this ride id ${thisRideId}");
        newRideRef.set('accepted');
        HelperMethods.disableHomeTabLocationUpdates();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewTripPage(
              tripDetails: tripDetails,
            ),
          ),
        );
      } else if (thisRideId == 'cancelled') {
        print('ride has been cancelled');
        Fluttertoast.showToast(
            msg: "ride has been cancelled",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0);
      } else if (thisRideId == 'timeout') {
        print('ride has timed out');
        Fluttertoast.showToast(
            msg: "ride has timed out",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        print('rider not found');
        Fluttertoast.showToast(
            msg: "rider not found",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }
}
