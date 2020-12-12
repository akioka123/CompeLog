import 'package:CompeLog/model/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FireStoreService with ChangeNotifier {
  String uid;
  String logId;
  UserModel user;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  FireStoreService();

  CollectionReference get userColRef => _db.collection("User");

  DocumentReference get userPath => _db.collection("User").doc(uid);

  CollectionReference get logColRef => _db.collection("Log");

  DocumentReference get logPath => _db.collection("Log").doc(logId);
}
