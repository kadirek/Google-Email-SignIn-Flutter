import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("user");

  final String uid;
  FirestoreService({this.uid});

  Future updateUserData(String name, String email, DateTime birthDate) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'email': email,
      'dateOfBirth': birthDate.year,
    });
  }
}
