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
    phone = snapshot.value['phone'];
    email = snapshot.value['email'];
    fullname = snapshot.value['fullname'];
    carModel = snapshot.value['vehicle_details']['car_model'];
    carColor = snapshot.value['vehicle_details']['car_color'];
    vehicleNumber = snapshot.value['vehicle_details']['vehicle_number'];
  }
}
