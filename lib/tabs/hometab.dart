// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:cab_driver/brand_colors.dart';
import 'package:cab_driver/globalvariables.dart';
import 'package:cab_driver/widgets/TaxiButton.dart';
import 'package:cab_driver/widgets/availability_button.dart';
import 'package:cab_driver/widgets/confirm_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  GoogleMapController? mapController;
  Completer<GoogleMapController> _controller = Completer();

  Position? currentPosition;

  DatabaseReference? tripRequestRef;

  //var geoLocator = Geolocator();
  var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 4);
  Stream<Position>? geoLocator;

  String? availabilityTitile = 'GO ONLINE';
  Color availabilityColor = BrandColors.colorOrange;

  bool isAvailable = false;

  void getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    mapController!.animateCamera(
      CameraUpdate.newLatLng(pos),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          padding: EdgeInsets.only(top: 135.0),
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          initialCameraPosition: googlePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            mapController = controller;
            getCurrentPosition();
          },
        ),
        Container(
          height: 135,
          width: double.infinity,
          color: BrandColors.colorPrimary,
        ),
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AvailabilityButton(
                title: availabilityTitile,
                color: availabilityColor,
                onPressed: () {
                  showModalBottomSheet(
                    isDismissible: false,
                    context: context,
                    builder: (BuildContext context) => ConfirmSheet(
                      title: (!isAvailable) ? 'GO ONLINE' : 'GO OFFLINE',
                      subtitle: (!isAvailable)
                          ? 'You are about to become available to receive trip requests'
                          : 'You will stop receiving trip requests',
                      onPressed: () {
                        if (!isAvailable) {
                          geoLocator = Geolocator.getPositionStream(
                              desiredAccuracy:
                                  LocationAccuracy.bestForNavigation);
                          goOnline();
                          getLocationUpdates();
                          Navigator.pop(context);

                          setState(() {
                            availabilityColor = BrandColors.colorGreen;
                            availabilityTitile = 'GO OFFLINE';
                            isAvailable = true;
                            print(isAvailable);
                          });
                        } else {
                          geoLocator = null;
                          goOffline();
                          Navigator.pop(context);
                          setState(() {
                            availabilityColor = BrandColors.colorOrange;
                            availabilityTitile = 'GO ONLINE';
                            isAvailable = false;

                            print(isAvailable);
                          });
                          return;
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 30,
          right: 20,
          child: GestureDetector(
            onTap: () {
              LatLng pos =
                  LatLng(currentPosition!.latitude, currentPosition!.longitude);
              mapController!.animateCamera(
                CameraUpdate.newLatLng(pos),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(29),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 29,
                child: Icon(
                  Icons.my_location_rounded,
                  color: Colors.black54,
                  size: 27,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void goOffline() {
    Geofire.removeLocation(currentFirebaseUser!.uid);
    tripRequestRef!.onDisconnect();
    tripRequestRef!.remove();
    tripRequestRef = null;
    print("geoLocator $geoLocator");
  }

  void goOnline() {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;
    Geofire.initialize('driversAvailable');
    Geofire.setLocation(currentFirebaseUser!.uid, currentPosition!.latitude,
        currentPosition!.longitude);
    tripRequestRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentFirebaseUser!.uid}/newTrip');
    tripRequestRef!.set('waiting');

    tripRequestRef!.onValue.listen((event) {});
  }

  void getLocationUpdates() {
    homeTabPositionStream = geoLocator!.listen((Position position) {
      currentPosition = position;
      Geofire.setLocation(
          currentFirebaseUser!.uid, position.latitude, position.longitude);

      LatLng pos = LatLng(position.latitude, position.longitude);
      mapController!.animateCamera(
        CameraUpdate.newLatLng(pos),
      );
    });
  }
}
