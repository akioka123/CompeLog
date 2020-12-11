import 'package:cloud_firestore/cloud_firestore.dart';

void createCompeLog(FirebaseFirestore db) {
  for (int i = 1; i <= 60; i++) {
    if (i <= 3) {
      db
          .collection("Log")
          .add({"class": "８級", "clear": [], "number": i, "wall": "垂壁"});
    } else if (i <= 6) {
      db
          .collection("Log")
          .add({"class": "７級", "clear": [], "number": i, "wall": "垂壁"});
    } else if (i <= 10) {
      db
          .collection("Log")
          .add({"class": "６級", "clear": [], "number": i, "wall": "垂壁"});
    } else if (i <= 21) {
      db
          .collection("Log")
          .add({"class": "５級", "clear": [], "number": i, "wall": "垂壁"});
    } else if (i <= 33) {
      db
          .collection("Log")
          .add({"class": "４級", "clear": [], "number": i, "wall": "垂壁"});
    } else if (i <= 43) {
      db
          .collection("Log")
          .add({"class": "３級", "clear": [], "number": i, "wall": "垂壁"});
    } else if (i <= 53) {
      db
          .collection("Log")
          .add({"class": "２級", "clear": [], "number": i, "wall": "垂壁"});
    } else if (i <= 56) {
      db
          .collection("Log")
          .add({"class": "１級", "clear": [], "number": i, "wall": "垂壁"});
    } else if (i <= 58) {
      db
          .collection("Log")
          .add({"class": "初段", "clear": [], "number": i, "wall": "垂壁"});
    } else if (i <= 60) {
      db
          .collection("Log")
          .add({"class": "二段", "clear": [], "number": i, "wall": "垂壁"});
    }
  }
}
