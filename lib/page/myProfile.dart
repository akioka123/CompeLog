import 'dart:io' as io;

import 'package:CompeLog/const.dart';
import 'package:CompeLog/model/userModel.dart';
import 'package:CompeLog/textUtil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

///ユーザー情報表示
///他者からも閲覧可能
class MyProfile extends StatefulWidget {
  final String authId;
  MyProfile(this.authId);
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  ///結果一覧
  List<Widget> _myResultList = [];
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  UserModel _user = UserModel();
  int _current = 0;
  final _picker = ImagePicker();
  io.File _profImage;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  TaskSnapshot _task;

  void initState() {
    super.initState();
    print("プロフィール画面");
  }

  void dispose() {
    super.dispose();
  }

  /// 名前・性別・クラスの表示
  Widget _nameAgeGenderRow(UserModel user) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(padding: EdgeInsets.all(20.0)),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textToJap(user.name,
                  style: Theme.of(context).textTheme.headline1),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textToJap(user.gender,
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textToJap(user.className,
                  style: Theme.of(context).textTheme.headline1)
            ],
          ),
        ],
      ),
      IconButton(
          iconSize: 35.0,
          icon: Icon(Icons.edit_sharp),
          onPressed: () async {
            final result =
                await Navigator.pushNamed(context, "/edit", arguments: _user);
            if (result != null) {
              setState(() {
                _user = result;
                _db.collection("User").doc(_user.id).update({
                  "name": _user.name,
                  "class": _user.className,
                  "gender": _user.gender
                });
              });
            } else {
              setState(() {});
            }
          })
    ]);
  }

  ///結果一覧の表示
  Widget _clearResult(Map result) {
    /// _resultList作成
    _myResultList = [];
    String key;
    num value;
    for (int i = 0; i < CLASS_STR_LIST.length; i++) {
      key = CLASS_STR_LIST[i];
      value = result[CLASS_STR_LIST[i]];
      List<Widget> rowList = [];
      rowList.add(Row(children: [
        textToJap(key + " :", style: TextStyle(color: CLASS_COLOR_MAP[key])),
        Padding(padding: EdgeInsets.only(left: 1.5)),
        textToJap(value.toString(),
            style: Theme.of(context).textTheme.bodyText1),
        Padding(padding: EdgeInsets.only(left: 30.0)),
      ]));
      i++;
      key = CLASS_STR_LIST[i];
      value = result[CLASS_STR_LIST[i]];
      rowList.add(Row(children: [
        textToJap(key + " :", style: TextStyle(color: CLASS_COLOR_MAP[key])),
        Padding(padding: EdgeInsets.only(left: 1.5)),
        textToJap(value.toString(),
            style: Theme.of(context).textTheme.bodyText1),
      ]));
      _myResultList.add(Row(children: rowList));
    }
    // result.forEach((key, value) {
    //   _myResultList.add(Row(children: [
    //     textToJap(key + " :", style: Theme.of(context).textTheme.bodyText1),
    //     Padding(padding: EdgeInsets.only(left: 1.5)),
    //     textToJap(value.toString(),
    //         style: Theme.of(context).textTheme.bodyText1),
    //   ]));

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Column(
          mainAxisAlignment: MainAxisAlignment.center, children: _myResultList),
    ]);
  }

  ///画像選択
  Future _getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _db
            .collection("User")
            .doc(_user.id)
            .update({"profImage": pickedFile.path});
        uploadImage(pickedFile);
        _profImage = io.File(pickedFile.path);
      }
    });
  }

  /// firebase storageにプロフ画像アップ
  void uploadImage(PickedFile file) {
    try {
      Reference ref =
          _storage.ref().child("ProfImage").child("/" + _user.id + "_prof.png");
      final metadata = SettableMetadata(
          contentType: 'image/png',
          customMetadata: {'picked-file-path': file.path});
      ref.putFile(io.File(file.path), metadata);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  ///画面表示
  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments;
    id = widget.authId;
    return Scaffold(
      appBar: AppBar(title: textToJap("プロフィール")),
      body: FutureBuilder(
        future: _db.collection("User").doc(id).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text(
              "問題が発生しました。",
              locale: Locale("ja"),
              style: Theme.of(context).textTheme.bodyText2,
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          Map data = snapshot.data.data();
          // ログデータの表示処理部分
          debugPrint("get snapshot data :" + snapshot.toString());
          _user.id = id;
          _user.name = data["name"];
          _user.gender = data["gender"];
          _user.className = data["class"];
          _user.result = data["result"];
          _user.profImage = data["profImage"];
          if (_user.profImage != null) {
            _profImage = io.File(_user.profImage);
          }

          return Container(
            child: Column(
              children: [
                _profImage == null
                    ? Container(
                        height: MediaQuery.of(context).size.width *
                            0.7 *
                            MediaQuery.of(context).size.aspectRatio,
                        width: MediaQuery.of(context).size.width,
                        color: ClearLog,
                        child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: _getImage,
                        ))
                    : Container(
                        height: MediaQuery.of(context).size.width *
                            0.7 *
                            MediaQuery.of(context).size.aspectRatio,
                        width: MediaQuery.of(context).size.width,
                        color: ClearLog,
                        child: GestureDetector(
                            behavior: HitTestBehavior.deferToChild,
                            onTap: _getImage,
                            child: Image.file(_profImage))),
                _nameAgeGenderRow(_user),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.03),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Card(
                          child: _clearResult(_user.result),
                          elevation: 5.0,
                        ))),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: makeBottomNavi(context, _current, _user),
    );
  }
}
