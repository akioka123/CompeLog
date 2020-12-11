import 'package:CompeLog/devFunc/createLog.dart';
import 'package:CompeLog/model/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

User _firebaseUser;
UserModel _user = UserModel();
final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _db = FirebaseFirestore.instance;
bool _isOnce = true;

void _getUser(BuildContext context) async {
  _firebaseUser = _auth.currentUser;

  if (_firebaseUser == null) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      debugPrint("未ログイン：新規登録画面へ");
      Fluttertoast.showToast(msg: "新規登録してください。");
      Navigator.pushReplacementNamed(context, "/signin");
    });
  } else {
    DocumentSnapshot userDoc =
        await _db.collection("User").doc(_firebaseUser.uid).get();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      debugPrint("ログイン済：自分のログ画面へ");
      Fluttertoast.showToast(msg: _firebaseUser.displayName + "でログインしました。");
      UserModel user = UserModel();
      user.id = _firebaseUser.uid;
      user.name = userDoc["name"];
      user.gender = userDoc["gender"];
      user.className = userDoc["class"];
      user.result = userDoc["result"];
      Navigator.pushReplacementNamed(context, "/profile",
          arguments: _firebaseUser.uid);
    });
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _getUser(context);
    return Scaffold(
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
