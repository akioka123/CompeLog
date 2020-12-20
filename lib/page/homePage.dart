import 'package:CompeLog/devFunc/createLog.dart';
import 'package:CompeLog/model/fireStoreService.dart';
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
bool _isOnce = true;

void _getUser(BuildContext context) async {
  _firebaseUser = _auth.currentUser;
  final fireStoreService = Provider.of<FireStoreService>(context);

  if (_firebaseUser == null) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      debugPrint("未ログイン：新規登録画面へ");
      Fluttertoast.showToast(msg: "新規登録してください。");
      Navigator.pushReplacementNamed(context, "/signin");
    });
  } else {
    fireStoreService.uid = _firebaseUser.uid;
    DocumentSnapshot userDoc = await fireStoreService.userPath.get();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      debugPrint("ログイン済：自分のログ画面へ");
      Fluttertoast.showToast(msg: _firebaseUser.displayName + "でログインしました。");
      UserModel user = UserModel();
      user.id = _firebaseUser.uid;
      user.name = userDoc["name"];
      user.gender = userDoc["gender"];
      user.className = userDoc["class"];
      user.result = userDoc["result"];
      fireStoreService.user = user;
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
