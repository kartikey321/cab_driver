// ignore_for_file: file_names, prefer_const_constructors

import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cab_driver/datamodels/driver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String mapKey = 'AIzaSyCHeaBTio-AeysW6em7vfoiMR6qWBTJOBY';

User? currentFirebaseUser;

final CameraPosition googlePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

StreamSubscription<Position>? homeTabPositionStream;

StreamSubscription<Position>? ridePositionStream;

final assetsAudioPlayer = AssetsAudioPlayer();

Position? currentPosition;

DatabaseReference? rideRef;

Driver? currentDriverInfo;
