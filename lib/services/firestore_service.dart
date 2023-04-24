import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future<QuerySnapshot> getUsers() {
    return usersCollection.get();
  }

  Future<void> addUser(String name) async {
    await usersCollection.doc().set({'name': name});
  }
}
