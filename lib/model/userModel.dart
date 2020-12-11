import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserModel {
  String id = "";
  String name = "";
  String gender = "";
  String className = "";
  Map result = {};
  String profImage = "";

  UserModel(
      {this.id,
      this.name,
      this.gender,
      this.className,
      this.result,
      this.profImage});
}

// class UserNotifer with ChangeNotifier {
//   UserModel _user;

//   UserModel get user => _user;
//   UserNotifer(UserModel user) {
//     _user = user;
//   }

//   void setValue(id, name, gender, className, result) {
//     _user.id = id;
//     _user.name = name;
//     _user.gender = gender;
//     _user.className = className;
//     _user.result = result;
//     notifyListeners();
//   }

//   void incrementResult(String tgt) {
//     _user.result[tgt]++;
//     notifyListeners();
//   }

//   void decrementResult(String tgt) {
//     _user.result[tgt]--;
//     notifyListeners();
//   }
// }

// class UserInfoNotifer with ChangeNotifier {
//   String id = "";
//   String name = "";
//   String gender = "";
//   String className = "";
//   Map result = {};

//   UserModel get user => _user;
//   UserNotifer(UserModel user) {
//     _user = user;
//   }

//   void setValue(id, name, gender, className, result) {
//     _user.id = id;
//     _user.name = name;
//     _user.gender = gender;
//     _user.className = className;
//     _user.result = result;
//     notifyListeners();
//   }

//   void incrementResult(String tgt) {
//     _user.result[tgt]++;
//     notifyListeners();
//   }

//   void decrementResult(String tgt) {
//     _user.result[tgt]--;
//     notifyListeners();
//   }
// }
