import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final CollectionReference attractionsCollection =
      FirebaseFirestore.instance.collection('attractions');

  Future<void> addAttraction(String name, String description, String location,
      String workingHours, String ticketPrice, String contactInfo) async {
    try {
      await attractionsCollection.add({
        'name': name,
        'description': description,
        'location': location,
        'working_hours': workingHours,
        'ticket_price': ticketPrice,
        'contact_info': contactInfo
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
