import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cab_driver/datamodels/tripDetails.dart';
import 'package:cab_driver/globalvariables.dart';
import 'package:cab_driver/widgets/ProgressDialog.dart';
import 'package:cab_driver/widgets/notification_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'main.dart';

Map<String, dynamic>? notifdata;

String? ride_id;
void notif(context) async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    notifdata = message.data;
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null) {
      NotificationsData notificationsData = NotificationsData();
      notificationsData.fetchRideInfo(notificationsData.getRideId(), context);
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              color: Colors.blue,
              playSound: true,
              icon: '@mipmap/ic_launcher',
            ),
          ));
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
    print(message);
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      NotificationsData notificationsData = NotificationsData();
      notificationsData.fetchRideInfo(notificationsData.getRideId(), context);
    }
  });
}

class NotificationsData {
  String? token;
  var messaging = FirebaseMessaging.instance;

  Future<String?> getToken() async {
    token = await messaging.getToken();
    print("token: $token");
    DatabaseReference tokenRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentFirebaseUser!.uid}/token');
    tokenRef.set(token);
    messaging.subscribeToTopic('alldrivers');
    messaging.subscribeToTopic('allusers');
    return token;
  }

  String getRideId() {
    String ride_id = notifdata!['ride_id'];
    //fetchRideInfo(ride_id);
    print("ride_id: $ride_id");

    return ride_id;
  }

  void fetchRideInfo(String rideId, context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              status: 'Fetching Details... ',
            ));
    DatabaseReference rideRef =
        FirebaseDatabase.instance.reference().child('rideRequest/$rideId');
    rideRef.once().then((DataSnapshot snapshot) {
      Navigator.pop(context);
      print(rideId);
      print(snapshot.value);
      if (snapshot.value != null) {
        assetsAudioPlayer.open(
          Audio('assets/sounds/alert.mp3'),
        );
        assetsAudioPlayer.play();

        double pickupLat =
            double.parse(snapshot.value['location']['latitude'].toString());
        double pickupLng =
            double.parse(snapshot.value['location']['longitude'].toString());
        String pickupAddress = snapshot.value['pickup_address'].toString();

        double destinationLat =
            double.parse(snapshot.value['destination']['latitude'].toString());
        double destinationLng =
            double.parse(snapshot.value['destination']['longitude'].toString());
        String destinationAddress =
            snapshot.value['destination_address'].toString();
        String paymentMethod = snapshot.value['payment_method'];
        String riderName = snapshot.value['rider_name'];
        String riderPhone = snapshot.value['rider_phone'];

        TripDetails tripDetails = TripDetails();
        tripDetails.rideId = rideId;

        tripDetails.pickupAddress = pickupAddress;
        tripDetails.destinationAddress = destinationAddress;
        tripDetails.pickup = LatLng(pickupLat, pickupLng);
        tripDetails.destination = LatLng(destinationLat, destinationLng);
        tripDetails.paymentMethod = paymentMethod;
        tripDetails.riderName = riderName;
        tripDetails.riderPhone = riderPhone;
        print('ride_id   $ride_id');
        print('ride id   ${tripDetails.rideId}');

        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) => NotificationDialog(
                  tripDetails: tripDetails,
                ));
      }
    });
  }
}
