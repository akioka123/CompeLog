import 'package:CompeLog/const.dart';
import 'package:CompeLog/model/userModel.dart';
import 'package:CompeLog/textUtil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  final UserModel user;
  EditProfile(this.user);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  UserModel _user = UserModel();

  ///クラス選択　初期値
  String _chosenClass;

  ///性別選択　初期値
  String _chosenGender;

  void initState() {
    super.initState();
    _nameController.text = widget.user.name;
    _chosenClass = widget.user.className;
    _chosenGender = widget.user.gender;
  }

  /// 各種入力欄　パッドセット
  /// hgt：高さ　wdh：幅
  Widget _fieldBox(Widget inBox, double hgt, double wdh) {
    return Padding(
        padding: EdgeInsets.all(4.0),
        child: SizedBox(
          height: hgt,
          width: wdh,
          child: inBox,
        ));
  }

  /// 名前入力欄
  Widget _buildNameInputField() {
    return Container(
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: _nameController,
        decoration: const InputDecoration(
          labelText: 'Account',
          counterStyle: TextStyle(),
          hintText: '10文字以内で入力してください。',
          border: OutlineInputBorder(),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'アカウント名を入力してください';
          } else if (value.length >= 10) {
            return 'アカウント名は10文字以内にしてください。';
          }
          return null;
        },
      ),
    );
  }

  /// 性別選択欄
  Widget _buildGenderSelectField() {
    return Container(
      child: DropdownButton<String>(
          value: _chosenGender,
          items: SEX_LIST,
          hint: Text("選択"),
          onChanged: (String chosen) {
            setState(() {
              _chosenGender = chosen;
            });
          }),
    );
  }

  /// クラス選択欄
  Widget _buildClassSelectField() {
    return Container(
      child: DropdownButton<String>(
          value: _chosenClass,
          items: CLASS_LIST,
          hint: Text("選択"),
          onChanged: (String chosen) {
            setState(() {
              _chosenClass = chosen;
            });
          }),
    );
  }

  void _register(BuildContext context) {
    _user = widget.user;
    _user.name = _nameController.text;
    _user.className = _chosenClass;
    _user.gender = _chosenGender;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: textToJap("プロフィール編集")),
        body: Center(
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    // 名前　入力欄
                    _fieldBox(_buildNameInputField(), 80.0, 200.0),

                    // 性別　入力欄
                    _fieldBox(_buildGenderSelectField(), 40.0, 80.0),

                    // クラス　入力欄
                    _fieldBox(_buildClassSelectField(), 40.0, 130.0),

                    // 新規登録ボタン
                    RaisedButton(
                      color: Colors.white,
                      child: textToJap('編集完了',
                          style: Theme.of(context).textTheme.bodyText1),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _register(context);
                          Navigator.pop(context, _user);
                        }
                      },
                    ),
                  ]))),
        ));
  }
}
