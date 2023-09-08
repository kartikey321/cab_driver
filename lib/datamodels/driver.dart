import 'package:firebase_database/firebase_database.dart';

class Driver {
  String? fullname;
  String? email;
  String? phone;
  String? id;
  String? carModel;
  String? carColor;
  String? vehicleNumber;

  Driver(
      {this.carColor,
      this.carModel,
      this.email,
      this.fullname,
      this.id,
      this.phone,
      this.vehicleNumber});

  Driver.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    var data = snapshot.value as Map<dynamic, dynamic>?;
    phone = data!['phone'];
    email = data['email'];
    fullname = data['fullname'];
    carModel = data['vehicle_details']['car_model'];
    carColor = data['vehicle_details']['car_color'];
    vehicleNumber = data['vehicle_details']['vehicle_number'];
  }
}
