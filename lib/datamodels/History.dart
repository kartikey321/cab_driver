import 'package:firebase_database/firebase_database.dart';

class History {
  String? pickup;
  String? destination;
  String? fares;
  String? status;
  String? createdAt;
  String? paymentMethod;

  History(
      {this.createdAt,
      this.destination,
      this.fares,
      this.paymentMethod,
      this.pickup,
      this.status});

  History.fromSnapshot(DataSnapshot snapshot) {
    var data = snapshot.value as Map<String, dynamic>;
    pickup = data['pickup_address'];
    destination = data['destination_address'];
    fares = data['fares'].toString();
    createdAt = data['created_at'];
    status = data['status'];
    paymentMethod = data['payment_method'];
  }
}
