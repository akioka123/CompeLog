import 'package:CompeLog/model/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FireStoreService with ChangeNotifier {
  String uid;
  String logId;
  UserModel user;

  final FirebaseFirestore db = FirebaseFirestore.instance;

  FireStoreService();

  CollectionReference get userColRef => db.collection("User");

  DocumentReference get userPath => db.collection("User").doc(uid);

  CollectionReference get logColRef => db.collection("Log");

  DocumentReference get logPath => db.collection("Log").doc(logId);
}
